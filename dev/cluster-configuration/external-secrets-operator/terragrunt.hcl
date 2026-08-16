locals {
  global_config = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  module_repo = local.global_config.leonomano_modules_repo
  tf_branch = get_env("TF_SOURCE_BRANCH", "main")
}

terraform {
  source = "${local.module_repo}//cluster-configuration/external-secrets-operator?ref=${local.tf_branch}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  cluster_profile = feature.state_path_prefix.value != "" ? feature.state_path_prefix.value : ""
}
