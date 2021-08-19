terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "network" {
  source = "./modules/network"
}

module "nginx" {
  source = "./modules/nginx"
  aws_vpc_id = module.network.aws_vpc_id
  aws_priv_subnet = module.network.aws_priv_subnet
  aws_pub_subnet = module.network.aws_pub_subnet
}