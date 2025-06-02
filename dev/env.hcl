locals {
  env = "dev"
  aws_account = {
    name     = "leonomano"
    id       = "378041425110"
    region   = "us-east-1"
    role_arn = "arn:aws:iam::378041425110:role/dev-leonomano-do-k8s-cluster-tf-service-role"
  }
  backend = {
    bucket           = "dev-leonomano-do-k8s-cluster-tf-state-378041425110-us-east-1"
    dynamodb_table   = "dev-leonomano-do-k8s-cluster-tf-state-378041425110-us-east-1"
    encrypt          = true
    restrict_account = true
  }
}
