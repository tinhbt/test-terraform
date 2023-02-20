#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.VPC_CIDR

  tags = {
    Name = "${var.ENV}-${var.PROJECT_NAME}"
  }
}
#Create subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id #get vpc id

  for_each                = var.PUBLIC_SUBNET_NUMBERS
  availability_zone       = each.key
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
  tags = {
    Name   = "${var.ENV}-${var.PROJECT_NAME}-public-subnet"
    Role   = "public"
    Subnet = "${each.key}-${each.value}"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id #get vpc id

  for_each                = var.PRIVATE_SUBNET_NUMBERS
  availability_zone       = each.key
  map_public_ip_on_launch = false
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)
  tags = {
    Name   = "${var.ENV}-${var.PROJECT_NAME}-private-subnet"
    Role   = "private"
    Subnet = "${each.key}-${each.value}"
  }
}

#Create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.ENV}-${var.PROJECT_NAME}"
  }
}
#Create rtb with route and subnet association
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.ENV}-${var.PROJECT_NAME}"
  }
}
##route to internet
resource "aws_route" "public" {
  route_table_id = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
##Associate with public subnet
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rtb.id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}