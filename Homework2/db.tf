resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db subnets"
  subnet_ids = [for subnet in aws_subnet.private: subnet.id]
  tags = {
    Name ="DataBase subnets"
  }
}
resource "aws_db_instance" "db_ops" {
  name = "DBOps"
  count = 2
  instance_class = "db.t2.micro"
  allocated_storage = 10
  skip_final_snapshot = "true"
  storage_type = "gp2"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.name}"
  engine = "mysql"
  engine_version = "5.7"
  username = "Anna_ops"
  password = "Anna7ops8"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  tags = {
    Name = "db-${count.index}"
    owner = "Grandpa"
    purpose = "db_whisky"
    }
}



