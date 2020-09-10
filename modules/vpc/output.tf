output "vpc_id" {
  value = aws_vpc.default.id
}

output "rds_subnet_id" {
  value = aws_subnet.us-east-1a-private-rds.id
}

output "private_subnet_id" {
  value = aws_subnet.us-east-1a-private-ec2.id
}

output "public_subnet_id" {
  value = aws_subnet.us-east-1a-public.id
}

