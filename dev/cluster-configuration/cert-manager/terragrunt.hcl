locals {
  global_config = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
  module_repo = local.global_config.leonomano_modules_repo
  tf_branch = get_env("TF_SOURCE_BRANCH", "main")
}

feature "kube_ctx" {
  default = "minikube"
}

feature "kube_config_path" {
  default = "~/.kube/config"
}

terraform {
  source = "${local.module_repo}//cluster-configuration/cert-manager?ref=${local.tf_branch}"
  before_hook "remove_aws_provider" {
    commands = ["init", "plan", "apply", "destroy"]
    execute  = [
      "bash", "-c",
      "rm -vf aws.provider.tf"
    ]
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  kube_ctx         = feature.kube_ctx.value
  kube_config_path = feature.kube_config_path.value
}
