provider "aws" {
    region = "ap-south-1"
    secret_key = ""
    access_key = ""
  
}
resource "aws_vpc" "Krish" {
  cidr_block           = "120.0.0.0/18"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "Krish"
  }
  
}
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.Krish.id
  cidr_block              = "120.0.1.0/24"
  availability_zone       = "ap-south-1b"
  tags = {
    "Name" = "Public Subnet"
  }
  
}
resource "aws_subnet" "Private" {
   vpc_id                  = aws_vpc.Krish.id
  cidr_block              = "120.0.2.0/24"
  availability_zone       = "ap-south-1c"
  tags = {
    "Name" = "Private Subnet"
  } 
  
}
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.Krish.id
    tags = {
      "Name" = "IGW"
    }
  
}
resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.Krish.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    "Name" = "PublicRT"
  }
  
}
resource "aws_eip" "Nat" {
    vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.Nat.id
  subnet_id     = aws_subnet.Public.id
  tags = {
    "Name" = "Nat-gw"
  }
  
}

resource "aws_route_table" "PrivateRT" {
    vpc_id = aws_vpc.Krish.id
    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    "Name" = "Private RT"
  }
  
}
resource "aws_route_table_association" "Public" {
    subnet_id = aws_subnet.Public.id
    route_table_id = aws_route_table.PublicRT.id
  
}
resource "aws_route_table_association" "Private" {
    subnet_id = aws_subnet.Private.id
    route_table_id = aws_route_table.PrivateRT.id
  
}
