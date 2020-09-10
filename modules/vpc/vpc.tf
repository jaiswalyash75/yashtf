resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "yash-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "yash-igw"
  }

  depends_on = [aws_vpc.default]
}

resource "aws_eip" "nat" {
  vpc = true
}



/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1a-public" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "yash-public"
  }

  depends_on = [aws_vpc.default]
}

resource "aws_route_table" "us-east-1a-public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "yash-rt-public"
  }

  depends_on = [aws_vpc.default, aws_internet_gateway.igw]
}

resource "aws_route_table_association" "eu-east-1a-public" {
  subnet_id      = aws_subnet.us-east-1a-public.id
  route_table_id = aws_route_table.us-east-1a-public.id
  depends_on     = [aws_subnet.us-east-1a-public, aws_route_table.us-east-1a-public]
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.us-east-1a-public.id

  tags = {
    Name = "yash-natgw"
  }
  depends_on = [aws_eip.nat, aws_subnet.us-east-1a-public]
}


/*
  Private Subnets
*/
resource "aws_subnet" "us-east-1a-private-rds" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.private_subnet_cidr1
  availability_zone = "us-east-1a"

  tags = {
    Name = "yash-private-rds"
  }
  depends_on = [aws_vpc.default]

}

resource "aws_subnet" "us-east-1b-private-ec2" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.private_subnet_cidr2
  availability_zone = "us-east-1b"

  tags = {
    Name = "yash-private-ec2"
  }
  depends_on = [aws_vpc.default]
}

resource "aws_route_table" "us-east-1-private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "yash-rt-private"
  }
  depends_on = [aws_vpc.default]
}

resource "aws_route_table_association" "us-east-1a-private-rds" {
  subnet_id      = aws_subnet.us-east-1a-private-rds.id
  route_table_id = aws_route_table.us-east-1-private.id
  depends_on     = [aws_subnet.us-east-1a-private-rds, aws_route_table.us-east-1-private]
}

resource "aws_route_table_association" "us-east-1b-private-ec2" {
  subnet_id      = aws_subnet.us-east-1b-private-ec2.id
  route_table_id = aws_route_table.us-east-1-private.id
  depends_on     = [aws_subnet.us-east-1b-private-ec2, aws_route_table.us-east-1-private]
}