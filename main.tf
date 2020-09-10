provider "aws" {
  region = var.aws_region #setting region
}

module "vpc" {
  source = "./modules/vpc"
}


module "public" {
  source = "./modules/public"
  vpc_id = module.vpc.vpc_id
  subnet_id= module.vpc.public_subnet_id
}



