region = "eu-west-1"
main_vpc_enable_dns_hostnames = true
main_vpc_enable_dns_support = true
main_vpc_tags = {
  Name = "gdpr-vpc"
}
main_vpc_cidr_block = "10.0.0.0/16"
public_subnet_availability_zone = "eu-west-1a"
public_subnet_map_public_ip_on_launch = true
public_subnet_tags = {
  Name = "public-subnet"
}
public_subnet_vpc_id = "${aws_vpc.main_vpc.id}"
public_subnet_cidr_block = "10.0.1.0/24"
private_subnet_vpc_id = "${aws_vpc.main_vpc.id}"
private_subnet_cidr_block = "10.0.2.0/24"
private_subnet_availability_zone = "eu-west-1a"
private_subnet_map_public_ip_on_launch = false
private_subnet_tags = {
  Name = "private-subnet"
}
internet_gateway_vpc_id = "${aws_vpc.main_vpc.id}"
internet_gateway_tags = {
  Name = "main-igw"
}
public_route_table_route = [{
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}]
public_route_table_tags = {
  Name = "public-route-table"
}
public_route_table_vpc_id = "${aws_vpc.main_vpc.id}"
public_route_table_assoc_subnet_id = "${aws_subnet.public_subnet.id}"
public_route_table_assoc_route_table_id = "${aws_route_table.public_route_table.id}"
nat_gateway_eip_vpc = true
nat_gateway_allocation_id = "${aws_eip.nat_gateway_eip.id}"
nat_gateway_subnet_id = "${aws_subnet.public_subnet.id}"
private_route_table_vpc_id = "${aws_vpc.main_vpc.id}"
private_route_table_route = [{
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}]
private_route_table_assoc_route_table_id = "${aws_route_table.private_route_table.id}"
private_route_table_assoc_subnet_id = "${aws_subnet.private_subnet.id}"
rds_sg_name = "rds-sg"
rds_sg_vpc_id = "${aws_vpc.main_vpc.id}"
rds_sg_ingress = [{
  cidr_blocks = ["10.0.0.0/16"]
  from_port = 5432
  protocol = "tcp"
  to_port = 5432
}]
rds_sg_egress = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
}]
ec2_sg_vpc_id = "${aws_vpc.main_vpc.id}"
ec2_sg_ingress = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  protocol = "tcp"
  to_port = 22
}]
ec2_sg_egress = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
}]
ec2_sg_name = "ec2-sg"
my_instance_key_name = "my-key"
my_instance_subnet_id = "${aws_subnet.private_subnet.id}"
my_instance_vpc_security_group_ids = ["${aws_security_group.ec2_sg.id}"]
my_instance_associate_public_ip_address = false
my_instance_root_block_device = {
  encrypted = true
  volume_size = 20
  volume_type = "gp2"
}
my_instance_tags = {
  Name = "GDPR-App-EC2"
}
my_instance_ami = "ami-0fc5d935ebf8bc3bc"
my_instance_instance_type = "t3.micro"
my_rds_allocated_storage = 20
my_rds_instance_class = "db.t3.micro"
my_rds_password = "securepassword123"
my_rds_db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.name}"
my_rds_vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
my_rds_storage_encrypted = true
my_rds_skip_final_snapshot = true
my_rds_backup_retention_period = 7
my_rds_engine = "postgres"
my_rds_engine_version = "13.4"
my_rds_name = "gdprdb"
my_rds_username = "admin"
my_rds_deletion_protection = true
rds_subnet_group_subnet_ids = ["${aws_subnet.private_subnet.id}"]
rds_subnet_group_tags = {
  Name = "RDS Subnet Group"
}
rds_subnet_group_name = "rds-subnet-group"
my_bucket_bucket = "gdpr-compliant-data-store"
my_bucket_acl = "private"
my_bucket_server_side_encryption_configuration = {
  rule = {
  apply_server_side_encryption_by_default = {
  sse_algorithm = "AES256"
}
}
}
my_bucket_versioning = {
  enabled = true
}
my_bucket_logging = {
  target_bucket = "gdpr-compliant-data-store"
  target_prefix = "logs/"
}
my_bucket_force_destroy = true
my_bucket_block_public_acls = true
my_bucket_block_public_policy = true
my_bucket_ignore_public_acls = true
my_bucket_restrict_public_buckets = true
