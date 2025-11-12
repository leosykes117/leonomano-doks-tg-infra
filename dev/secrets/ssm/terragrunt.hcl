terraform {
  source = "tfr:///terraform-aws-modules/ssm-parameter/aws//wrappers?version=1.1.2"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  defaults = {
    create               = true
    tier                 = "Standard"
    value                = "change_me"
    ignore_value_changes = true
    type                 = "String"
    data_type            = "text"
    tags = {
      Terraform   = "true"
      TfModule    = "${path_relative_to_include()}"
      Environment = "dev"
    }
  }

  items = {
    digital_ocean_token = {
      name        = "/account-configuration/dev/digital_ocean_token"
      description = "Digital Ocean API Token"
      type        = "SecureString"
      secure_type = true
    }
    cloudflare_token = {
      name = "/account-configuration/dev/cluster-issuer-cloudflare-token"
      description = "Cloudflare token to be used by the Cluster Issuer to validate certificates by DNS‑01 challenge"
      type = "SecureString"
      secure_type = true
    }
    cloud_flare_doks_external_dns_token = {
      name = "/account-configuration/dev/doks-external-dns-cloudflare-token"
      description = "Cloudflare token to be used by External DNS to manage DNS records for DigitalOcean Kubernetes clusters"
      type = "SecureString"
      secure_type = true
    }
  }
}
