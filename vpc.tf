resource "aws_vpc" "root" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "RS VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.root.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet: ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.root.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Private Subnet: ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.root.id

  tags = {
    Name = "Gateway"
  }
}
resource "aws_route_table" "public_subnet_route" {
  vpc_id = aws_vpc.root.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private_subnet_route" {
  vpc_id = aws_vpc.root.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_subnet_route.id
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_subnet_route.id
}

