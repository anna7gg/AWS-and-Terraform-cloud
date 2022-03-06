resource "aws_internet_gateway" "main-igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw ${aws_vpc.main.id}"
    }
}

resource "aws_eip" "nat_eip" {
    count      = length(var.public_subnet)
    tags = {
        Name = "main-igw ${data.aws_availability_zones.available.names[count.index]}"
    }
}

resource "aws_nat_gateway" "nat" {
    count      = length(var.public_subnet)
    subnet_id = aws_subnet.public[count.index].id
    allocation_id = aws_eip.nat_eip[count.index].id
    depends_on = [aws_internet_gateway.main-igw]
    tags = {
        Name = "nat ${aws_subnet.public[count.index].tags.Name}"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table" "private-rt" {
    count = length(var.private_subnet)
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "private-route-table ${data.aws_availability_zones.available.names[count.index]}"
    }
}

resource "aws_route_table_association" "public-subnet" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-subnet" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}

resource "aws_route" "route-public" {
    route_table_id = aws_route_table.public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
}

resource "aws_route" "route-private" {
    count                  = length(var.private_subnet)
    route_table_id         = aws_route_table.private-rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
