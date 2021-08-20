terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "terraformstatenginx"
    key = "global/s3/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraformstate"
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "network" {
  source = "./modules/network"
  service_name = var.service_name
  aws_region = var.aws_region
}

module "nginx" {
  source = "./modules/nginx"
  aws_vpc_id = module.network.aws_vpc_id
  aws_priv_subnet = module.network.aws_priv_subnet
  aws_pub_subnet = module.network.aws_pub_subnet
  service_name = var.service_name
}