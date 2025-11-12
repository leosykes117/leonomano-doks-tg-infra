feature "state_path_prefix" {
  default = ""
}

locals {
  project_name     = "leonomano-do-k8s-cluster"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env              = local.environment_vars.locals.env
  aws_account_id   = local.environment_vars.locals.aws_account.id
  aws_account_name = local.environment_vars.locals.aws_account.name
  aws_region       = local.environment_vars.locals.aws_account.region
  role_arn         = local.environment_vars.locals.aws_account.role_arn
  backend_config   = local.environment_vars.locals.backend
  state_path_prefix = feature.state_path_prefix.value != "" ? "${feature.state_path_prefix.value}/" : ""

  default_tags = {
    Project = local.project_name
    Account = local.aws_account_name
    Env     = local.env
    Region  = local.aws_region
  }
}

# Generate an AWS provider block
generate "aws_provider" {
  path      = "aws.provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
  provider "aws" {
    region  = "${local.aws_region}"
    assume_role {
      role_arn = "${local.role_arn}"
      session_name = "terragrunt-service-role"
    }

    # Only these AWS Account IDs may be operated on by this template
    allowed_account_ids = ["${local.aws_account_id}"]
  }
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region         = local.aws_region
    bucket         = local.backend_config.bucket
    dynamodb_table = lookup(local.backend_config, "dynamodb_table", "")
    key            = "${path_relative_to_include()}/${local.state_path_prefix}terraform.tfstate"
    assume_role = {
      role_arn = local.role_arn
    }
    encrypt             = lookup(local.backend_config, "encrypt", false)
    allowed_account_ids = lookup(local.backend_config, "restrict_account", false) ? [local.aws_account_id] : []
  }
}

inputs = {
  project_name = local.project_name
  aws_region   = local.aws_region
  env          = local.env
  aws_default_tags = local.default_tags
}
