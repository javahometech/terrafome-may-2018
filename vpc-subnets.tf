resource "aws_vpc" "jobassist" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.vpc_tenency}"

  tags {
    Name = "jobassist-vpc"
  }
}

# Provision public subnets
resource "aws_subnet" "webservers" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.jobassist.id}"
  cidr_block              = "${element(var.webservers_cidr,count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names,count.index)}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "PublicSubnet-${count.index+1}"
  }
}

# Internet gateway for webservers subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.jobassist.id}"

  tags {
    Name = "main"
  }
}

# Create Route Table for Public Subnet

resource "aws_route_table" "pr" {
  vpc_id = "${aws_vpc.jobassist.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "pr"
  }
}

# Associate pr to webservers

resource "aws_route_table_association" "webservers_association" {
  count          = "${length(aws_subnet.webservers.*.id)}"
  subnet_id      = "${element(aws_subnet.webservers.*.id, count.index)}"
  route_table_id = "${aws_route_table.pr.id}"
  depends_on     = ["aws_subnet.webservers"]
}

# Create Private subnets

# Provision public subnets
resource "aws_subnet" "private-servers" {
  count      = "${length(data.aws_availability_zones.available.names)}"
  vpc_id     = "${aws_vpc.jobassist.id}"
  cidr_block = "${element(var.private_servers_cidr,count.index)}"

  tags {
    Name = "PrivateSubnet-${count.index+1}"
  }
}
