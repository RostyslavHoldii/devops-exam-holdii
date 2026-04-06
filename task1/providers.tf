terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com" 
    }
    region                      = "us-east-1" 
    key                         = "terraform.tfstate"
    bucket                      = "rholdii-tfstate-bucket"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true 
    skip_s3_checksum            = true  # 
  }
}

provider "digitalocean" {}
