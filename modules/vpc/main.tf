# VPC Setup - START
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  #   enable_dns_support   = true
  #   enable_dns_hostnames = true
  tags = {
    Name : "${var.project}-vpc"
    Project : var.project
  }
}
# VPC Setup - END

# IGW Setup - START
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project}-igw"
    Project = var.project
  }
}
# IGW Setup - END

# Subnet Setup - START
# Public Subnet Setup - START
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-public-subnet"
    Project = var.project
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name    = "${var.project}-public-rt"
    Project = var.project
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
# Public Subnet Setup - END

# NAT - START
resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name    = "${var.project}-ngw-eip"
    Project = var.project
  }
  depends_on = [ aws_internet_gateway.this ]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name    = "${var.project}-ngw"
    Project = var.project
  }
  depends_on = [ aws_internet_gateway.this ]
}
# NAT - END

# Private Subnet Setup - START
resource "aws_subnet" "private_zone_1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_zone_1_subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name    = "${var.project}-private-zone-1-subnet"
    Project = var.project
  }
}

resource "aws_route_table" "private_zone_1" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name    = "${var.project}-private-zone-1-rt"
    Project = var.project
  }
}

resource "aws_route_table_association" "private_zone_1" {
  subnet_id      = aws_subnet.private_zone_1.id
  route_table_id = aws_route_table.private_zone_1.id
}

resource "aws_subnet" "private_zone_2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_zone_2_subnet_cidr_block
  availability_zone = "ap-south-1b"
  tags = {
    Name    = "${var.project}-private-zone-2-subnet"
    Project = var.project
  }
}

resource "aws_route_table" "private_zone_2" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name    = "${var.project}-private-zone-2-rt"
    Project = var.project
  }
}

resource "aws_route_table_association" "private_zone_2" {
  subnet_id      = aws_subnet.private_zone_2.id
  route_table_id = aws_route_table.private_zone_2.id
}
# Private Subnet Setup - END
# Subnet Setup - END
