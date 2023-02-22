#create a VPC

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "main"
    }
  
}

resource "aws_subnet" "az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "az1"
  }
}

resource "aws_subnet" "az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "az2"
  }
}

resource "aws_subnet" "az3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "az3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main-rt"
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.az1.id
  route_table_id = aws_route_table.main.id
}