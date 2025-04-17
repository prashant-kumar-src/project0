provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_vpc" {
	  cidr_block = var.main_vpc_cidr_block
	  enable_dns_hostnames = var.main_vpc_enable_dns_hostnames
	  enable_dns_support = var.main_vpc_enable_dns_support
	  tags = var.main_vpc_tags
	}
resource "aws_subnet" "public_subnet" {
	  availability_zone = var.public_subnet_availability_zone
	  cidr_block = var.public_subnet_cidr_block
	  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
	  tags = var.public_subnet_tags
	  vpc_id = var.public_subnet_vpc_id
	  depends_on = [
		"aws_vpc.main_vpc",
	  ]
	}
resource "aws_subnet" "private_subnet" {
	  availability_zone = var.private_subnet_availability_zone
	  cidr_block = var.private_subnet_cidr_block
	  map_public_ip_on_launch = var.private_subnet_map_public_ip_on_launch
	  tags = var.private_subnet_tags
	  vpc_id = var.private_subnet_vpc_id
	  depends_on = [
		"aws_vpc.main_vpc",
	  ]
	}
resource "aws_internet_gateway" "internet_gateway" {
	  tags = var.internet_gateway_tags
	  vpc_id = var.internet_gateway_vpc_id
	  depends_on = [
		"aws_vpc.main_vpc",
	  ]
	}
resource "aws_route_table" "public_route_table" {
	  route = var.public_route_table_route
	  tags = var.public_route_table_tags
	  vpc_id = var.public_route_table_vpc_id
	  depends_on = [
		"aws_internet_gateway.internet_gateway",
	  ]
	}
resource "aws_route_table_association" "public_route_table_assoc" {
	  route_table_id = var.public_route_table_assoc_route_table_id
	  subnet_id = var.public_route_table_assoc_subnet_id
	  depends_on = [
		"aws_route_table.public_route_table",
		"aws_subnet.public_subnet",
	  ]
	}
resource "aws_eip" "nat_gateway_eip" {
	  vpc = var.nat_gateway_eip_vpc
	  depends_on = [
		"aws_internet_gateway.internet_gateway",
	  ]
	}
resource "aws_nat_gateway" "nat_gateway" {
	  allocation_id = var.nat_gateway_allocation_id
	  subnet_id = var.nat_gateway_subnet_id
	  depends_on = [
		"aws_eip.nat_gateway_eip",
	  ]
	}
resource "aws_route_table" "private_route_table" {
	  route = var.private_route_table_route
	  vpc_id = var.private_route_table_vpc_id
	  depends_on = [
		"aws_nat_gateway.nat_gateway",
	  ]
	}
resource "aws_route_table_association" "private_route_table_assoc" {
	  route_table_id = var.private_route_table_assoc_route_table_id
	  subnet_id = var.private_route_table_assoc_subnet_id
	  depends_on = [
		"aws_subnet.private_subnet",
		"aws_route_table.private_route_table",
	  ]
	}
resource "aws_security_group" "rds_sg" {
	  egress = var.rds_sg_egress
	  ingress = var.rds_sg_ingress
	  name = var.rds_sg_name
	  vpc_id = var.rds_sg_vpc_id
	  depends_on = [
		"aws_vpc.main_vpc",
	  ]
	}
resource "aws_security_group" "ec2_sg" {
	  egress = var.ec2_sg_egress
	  ingress = var.ec2_sg_ingress
	  name = var.ec2_sg_name
	  vpc_id = var.ec2_sg_vpc_id
	  depends_on = [
		"aws_vpc.main_vpc",
	  ]
	}
resource "aws_instance" "my_instance" {
	  ami = var.my_instance_ami
	  associate_public_ip_address = var.my_instance_associate_public_ip_address
	  instance_type = var.my_instance_instance_type
	  key_name = var.my_instance_key_name
	  root_block_device = var.my_instance_root_block_device
	  subnet_id = var.my_instance_subnet_id
	  tags = var.my_instance_tags
	  vpc_security_group_ids = var.my_instance_vpc_security_group_ids
	  depends_on = [
		"aws_subnet.private_subnet",
		"aws_security_group.ec2_sg",
	  ]
	}
resource "aws_db_instance" "my_rds" {
	  allocated_storage = var.my_rds_allocated_storage
	  backup_retention_period = var.my_rds_backup_retention_period
	  db_subnet_group_name = var.my_rds_db_subnet_group_name
	  deletion_protection = var.my_rds_deletion_protection
	  engine = var.my_rds_engine
	  engine_version = var.my_rds_engine_version
	  instance_class = var.my_rds_instance_class
	  name = var.my_rds_name
	  password = var.my_rds_password
	  skip_final_snapshot = var.my_rds_skip_final_snapshot
	  storage_encrypted = var.my_rds_storage_encrypted
	  username = var.my_rds_username
	  vpc_security_group_ids = var.my_rds_vpc_security_group_ids
	  depends_on = [
		"aws_security_group.rds_sg",
	  ]
	}
resource "aws_db_subnet_group" "rds_subnet_group" {
	  name = var.rds_subnet_group_name
	  subnet_ids = var.rds_subnet_group_subnet_ids
	  tags = var.rds_subnet_group_tags
	  depends_on = [
		"aws_subnet.private_subnet",
	  ]
	}
resource "aws_s3_bucket" "my_bucket" {
	  acl = var.my_bucket_acl
	  block_public_acls = var.my_bucket_block_public_acls
	  block_public_policy = var.my_bucket_block_public_policy
	  bucket = var.my_bucket_bucket
	  force_destroy = var.my_bucket_force_destroy
	  ignore_public_acls = var.my_bucket_ignore_public_acls
	  logging = var.my_bucket_logging
	  restrict_public_buckets = var.my_bucket_restrict_public_buckets
	  server_side_encryption_configuration = var.my_bucket_server_side_encryption_configuration
	  versioning = var.my_bucket_versioning
	}
