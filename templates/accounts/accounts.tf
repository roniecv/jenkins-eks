# AWS Organization Units Creation
# ===============================

resource "aws_organizations_organizational_unit" "organization" {
  for_each  = merge(local.organization...)
  name      = each.key

# Static id for parent/root account
  parent_id = "r-ieyu"

  tags = {
    Name = "${each.key}"
  }
}

# The following arguments are supported:
# Parameter   | Values      | Memo
# ------------|-------------|-------------
# name        | \<string\>  | The name for the organizational unit
# parent_id   | \<string\>  | ID of the parent organizational unit, which may be the root
# tags        | \<string\>  | (Optional) Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.

# AWS Accounts Creation
# =====================

resource "aws_organizations_account" "accounts" {
  for_each = merge(local.accounts...)
  name     = each.key
  email    = each.value.email
  parent_id = aws_organizations_organizational_unit.organization[each.value.ou].id

  #iam_user_access_to_billing = "DENY"

  tags = {
    Name = "${each.value.organization}-${each.value.appreff}-${each.value.ou}-${each.value.project}"
    org = "${each.value.organization}"
    appref = "${each.value.appreff}"
    env = "${each.value.ou}"
    project = "${each.value.project}"
  }
  depends_on = [
    aws_organizations_organizational_unit.organization
  ]
}

# The following arguments are required:
# Parameter   | Values      | Memo
# ------------|-------------|-------------
# email       | \<string\>  | (Required) Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account.
# name        | \<string\>  | (Required) Friendly name for the member account.

# Optional arguments:
# Parameter                   | Values      | Memo
# ----------------------------|-------------|-------------
# close_on_deletion           | true        | If true, a deletion event will close the account. Otherwise, it will only remove from the organization. This is not supported for GovCloud accounts.
# create_govcloud             | true        | Whether to also create a GovCloud account. The GovCloud account is tied to the main (commercial) account this resource creates. If true, the GovCloud account ID is available in the govcloud_id attribute. The only way to manage the GovCloud account with Terraform is to subsequently import the account using this resource.
# iam_user_access_to_billing  | DENY|ALLOW  | If set to ALLOW, the new account enables IAM users and roles to access account billing information if they have the required permissions. If set to DENY, then only the root user (and no roles) of the new account can access account billing information. If this is unset, the AWS API will default this to ALLOW. If the resource is created and this option is changed, it will try to recreate the account.
# parent_id                   | \<string\>  | Parent Organizational Unit ID or Root ID for the account. Defaults to the Organization default Root ID. A configuration must be present for this argument to perform drift detection.
# role_name                   | \<string\>  | The name of an IAM role that Organizations automatically preconfigures in the new member account. This role trusts the root account, allowing users in the root account to assume the role, as permitted by the root account administrator. The role has administrator permissions in the new member account. The Organizations API provides no method for reading this information after account creation, so Terraform cannot perform drift detection on its value and will always show a difference for a configured value after import unless ignore_changes is used.
# tags                        | \<string\>  | Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.


# AWS Users Assignment to Account 
# ===============================

data "aws_ssoadmin_instances" "this" {}

data "aws_ssoadmin_permission_set" "this" {
  for_each     = merge(local.ssoassignment...)
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = each.value.permissionset
}

data "aws_identitystore_user" "this" {
  for_each          = merge(local.ssoassignment...)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  filter {
    attribute_path  = "UserName"
    attribute_value = each.key
  }
}

resource "aws_ssoadmin_account_assignment" "users" {
  
  for_each = merge(local.ssoassignment...)

  target_type = "AWS_ACCOUNT"
  target_id = aws_organizations_account.accounts[each.value.accountname].id

  instance_arn = data.aws_ssoadmin_permission_set.this[each.key].instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.this[each.key].arn

  principal_type = "USER"
  principal_id   = data.aws_identitystore_user.this[each.key].user_id
}

# The following arguments are supported:
# Parameter           | Values                            | Memo
# --------------------|-----------------------------------|-------------
# instance_arn        | data permission set instance arn  | (Required, Forces new resource) The Amazon Resource Name (ARN) of the SSO Instance.
# permission_set_arn  | data permission set arn           | (Required, Forces new resource) The Amazon Resource Name (ARN) of the Permission Set that the admin wants to grant the principal access to.
# principal_id        | data identitystore user id        | (Required, Forces new resource) An identifier for an object in SSO, such as a user or group. PrincipalIds are GUIDs (For example, f81d4fae-7dec-11d0-a765-00a0c91e6bf6).
# principal_type      | \<string\>                        | (Required, Forces new resource) The entity type for which the assignment will be created. Valid values: USER, GROUP.
# target_id           | accounts created                  | (Required, Forces new resource) An AWS account identifier, typically a 10-12 digit string.
# target_type         | \<string\>                        | (Optional, Forces new resource) The entity type for which the assignment will be created. Valid values: AWS_ACCOUNT.
