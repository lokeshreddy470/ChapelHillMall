resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_eip" "nat" {
    vpc = true
}

/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1a-public" {
    vpc_id = "${aws_vpc.default.id}"
    map_public_ip_on_launch = true
    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_subnet" "us-east-1b-public" {
    vpc_id = "${aws_vpc.default.id}"
    map_public_ip_on_launch = true
    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "us-east-1b"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.us-east-1a-public.id}"
}

resource "aws_route_table" "us-east-1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-1b-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    route_table_id = "${aws_route_table.us-east-1a-public.id}"
}

resource "aws_route_table_association" "us-east-1b-public" {
    subnet_id = "${aws_subnet.us-east-1b-public.id}"
    route_table_id = "${aws_route_table.us-east-1a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-1a-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "us-east-1a-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "us-east-1a-private" {
    subnet_id = "${aws_subnet.us-east-1a-private.id}"
    route_table_id = "${aws_route_table.us-east-1a-private.id}"
}
