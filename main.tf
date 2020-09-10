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


module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  subnet_ids= [module.vpc.private_subnet_id,module.vpc.rds_subnet_id]
  security_groups= module.private.private_sg_id
}


module "private" {
  source = "./modules/private"
  vpc_id = module.vpc.vpc_id
  subnet_id= module.vpc.private_subnet_id
  address = module.rds.address
}

