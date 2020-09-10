variable "ami" {
  default = "ami-0c94855ba95c71c99"
}

variable "az1" {
  default = "us-east-1b"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "21031-yash"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "address" {}


variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}


