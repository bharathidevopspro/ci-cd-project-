#  Get available AZs
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

#  Public Subnets (2 AZ)
resource "aws_subnet" "public" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)

  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-ELB-${count.index}"
  }
}

# Private Subnets (2 AZ)
resource "aws_subnet" "private" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 2)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-EC2-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Route Table Association (Public)
resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#  Outputs (VERY IMPORTANT for modules)
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
