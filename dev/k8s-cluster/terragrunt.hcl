locals {
  tf_branch=get_env("TF_SOURCE_BRANCH", "main")
}

terraform {
  source = "git@github.com:leosykes117/leonomano-doks-tf-modules//k8s-cluster?ref=${local.tf_branch}"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  do_region = "sfo2"
  cluster_name = "dev-leonomano-projects"
  node_pools = [{
    name       = "default-pool"
    default    = true
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
    tags       = ["default-nodepool"]
  }]
}
