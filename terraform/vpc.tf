#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "zion" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "terraform-eks-zion-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_subnet" "zion" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.zion.id

  tags = tomap({
    "Name"                                      = "terraform-eks-zion-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_internet_gateway" "zion" {
  vpc_id = aws_vpc.zion.id

  tags = {
    Name = "terraform-eks-zion"
  }
}

resource "aws_route_table" "zion" {
  vpc_id = aws_vpc.zion.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zion.id
  }
}

resource "aws_route_table_association" "zion" {
  count = 2

  subnet_id      = aws_subnet.zion[count.index].id
 route_table_id = aws_route_table.zion.id
}