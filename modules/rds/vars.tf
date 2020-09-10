variable "allocated_storage" {
  default = 20
}

variable "identifier" {
  default = "yashdb"
}


variable "storage_type" {
  default = "gp2"
}


variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0.17"
}


variable "name" {
  default = "yashdb"
}


variable "username" {
  default = "yash"
}

variable "password" {
  default = "yashjazz"
}

variable "vpc_id" {}

variable "private_sg_id" {}

variable "subnet_ids" {}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}
