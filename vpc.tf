resource "aws_vpc" "big_iron_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "BigIronVPC"
  }
}

resource "aws_internet_gateway" "big_iron_igw" {
  vpc_id = aws_vpc.big_iron_vpc.id

  tags = {
    Name = "BigIronInternetGateway"
  }
}

resource "aws_eip" "nat_eip" {

  tags = {
    Name = "BigIronNATEIP"
  }
}


resource "aws_nat_gateway" "big_iron_ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "BigIronNATGateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.big_iron_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.zone
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.big_iron_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.zone

  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.big_iron_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.big_iron_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.big_iron_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.big_iron_ngw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}