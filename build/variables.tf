variable "region" {
  type = string
  default = "eu-west-1"
  description = "AWS region for provider"
}

variable "main_vpc_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "gdpr-vpc"
}
  description = "Resource main_vpc property tags"
}

variable "main_vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "Resource main_vpc property cidr_block"
}

variable "main_vpc_enable_dns_hostnames" {
  type = bool
  default = true
  description = "Resource main_vpc property enable_dns_hostnames"
}

variable "main_vpc_enable_dns_support" {
  type = bool
  default = true
  description = "Resource main_vpc property enable_dns_support"
}

variable "public_subnet_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "public-subnet"
}
  description = "Resource public_subnet property tags"
}

variable "public_subnet_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource public_subnet property vpc_id"
}

variable "public_subnet_cidr_block" {
  type = string
  default = "10.0.1.0/24"
  description = "Resource public_subnet property cidr_block"
}

variable "public_subnet_availability_zone" {
  type = string
  default = "eu-west-1a"
  description = "Resource public_subnet property availability_zone"
}

variable "public_subnet_map_public_ip_on_launch" {
  type = bool
  default = true
  description = "Resource public_subnet property map_public_ip_on_launch"
}

variable "private_subnet_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource private_subnet property vpc_id"
}

variable "private_subnet_cidr_block" {
  type = string
  default = "10.0.2.0/24"
  description = "Resource private_subnet property cidr_block"
}

variable "private_subnet_availability_zone" {
  type = string
  default = "eu-west-1a"
  description = "Resource private_subnet property availability_zone"
}

variable "private_subnet_map_public_ip_on_launch" {
  type = bool
  default = false
  description = "Resource private_subnet property map_public_ip_on_launch"
}

variable "private_subnet_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "private-subnet"
}
  description = "Resource private_subnet property tags"
}

variable "internet_gateway_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource internet_gateway property vpc_id"
}

variable "internet_gateway_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "main-igw"
}
  description = "Resource internet_gateway property tags"
}

variable "public_route_table_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource public_route_table property vpc_id"
}

variable "public_route_table_route" {
  type = list(object({ "cidr_block" = string, "gateway_id" = string }))
  default = [{
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}]
  description = "Resource public_route_table property route"
}

variable "public_route_table_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "public-route-table"
}
  description = "Resource public_route_table property tags"
}

variable "public_route_table_assoc_subnet_id" {
  type = string
  default = "${aws_subnet.public_subnet.id}"
  description = "Resource public_route_table_assoc property subnet_id"
}

variable "public_route_table_assoc_route_table_id" {
  type = string
  default = "${aws_route_table.public_route_table.id}"
  description = "Resource public_route_table_assoc property route_table_id"
}

variable "nat_gateway_eip_vpc" {
  type = bool
  default = true
  description = "Resource nat_gateway_eip property vpc"
}

variable "nat_gateway_allocation_id" {
  type = string
  default = "${aws_eip.nat_gateway_eip.id}"
  description = "Resource nat_gateway property allocation_id"
}

variable "nat_gateway_subnet_id" {
  type = string
  default = "${aws_subnet.public_subnet.id}"
  description = "Resource nat_gateway property subnet_id"
}

variable "private_route_table_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource private_route_table property vpc_id"
}

variable "private_route_table_route" {
  type = list(object({ "cidr_block" = string, "nat_gateway_id" = string }))
  default = [{
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}]
  description = "Resource private_route_table property route"
}

variable "private_route_table_assoc_subnet_id" {
  type = string
  default = "${aws_subnet.private_subnet.id}"
  description = "Resource private_route_table_assoc property subnet_id"
}

variable "private_route_table_assoc_route_table_id" {
  type = string
  default = "${aws_route_table.private_route_table.id}"
  description = "Resource private_route_table_assoc property route_table_id"
}

variable "rds_sg_ingress" {
  type = list(object({ "cidr_blocks" = list(string), "from_port" = number, "protocol" = string, "to_port" = number }))
  default = [{
  cidr_blocks = ["10.0.0.0/16"]
  from_port = 5432
  protocol = "tcp"
  to_port = 5432
}]
  description = "Resource rds_sg property ingress"
}

variable "rds_sg_egress" {
  type = list(object({ "cidr_blocks" = list(string), "from_port" = number, "protocol" = string, "to_port" = number }))
  default = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
}]
  description = "Resource rds_sg property egress"
}

variable "rds_sg_name" {
  type = string
  default = "rds-sg"
  description = "Resource rds_sg property name"
}

variable "rds_sg_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource rds_sg property vpc_id"
}

variable "ec2_sg_vpc_id" {
  type = string
  default = "${aws_vpc.main_vpc.id}"
  description = "Resource ec2_sg property vpc_id"
}

variable "ec2_sg_ingress" {
  type = list(object({ "cidr_blocks" = list(string), "from_port" = number, "protocol" = string, "to_port" = number }))
  default = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  protocol = "tcp"
  to_port = 22
}]
  description = "Resource ec2_sg property ingress"
}

variable "ec2_sg_egress" {
  type = list(object({ "cidr_blocks" = list(string), "from_port" = number, "protocol" = string, "to_port" = number }))
  default = [{
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  protocol = "-1"
  to_port = 0
}]
  description = "Resource ec2_sg property egress"
}

variable "ec2_sg_name" {
  type = string
  default = "ec2-sg"
  description = "Resource ec2_sg property name"
}

variable "my_instance_associate_public_ip_address" {
  type = bool
  default = false
  description = "Resource my_instance property associate_public_ip_address"
}

variable "my_instance_root_block_device" {
  type = object({ "encrypted" = bool, "volume_size" = number, "volume_type" = string })
  default = {
  encrypted = true
  volume_size = 20
  volume_type = "gp2"
}
  description = "Resource my_instance property root_block_device"
}

variable "my_instance_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "GDPR-App-EC2"
}
  description = "Resource my_instance property tags"
}

variable "my_instance_ami" {
  type = string
  default = "ami-0fc5d935ebf8bc3bc"
  description = "Resource my_instance property ami"
}

variable "my_instance_instance_type" {
  type = string
  default = "t3.micro"
  description = "Resource my_instance property instance_type"
}

variable "my_instance_key_name" {
  type = string
  default = "my-key"
  description = "Resource my_instance property key_name"
}

variable "my_instance_subnet_id" {
  type = string
  default = "${aws_subnet.private_subnet.id}"
  description = "Resource my_instance property subnet_id"
}

variable "my_instance_vpc_security_group_ids" {
  type = list(string)
  default = ["${aws_security_group.ec2_sg.id}"]
  description = "Resource my_instance property vpc_security_group_ids"
}

variable "my_rds_engine" {
  type = string
  default = "postgres"
  description = "Resource my_rds property engine"
}

variable "my_rds_engine_version" {
  type = string
  default = "13.4"
  description = "Resource my_rds property engine_version"
}

variable "my_rds_name" {
  type = string
  default = "gdprdb"
  description = "Resource my_rds property name"
}

variable "my_rds_username" {
  type = string
  default = "admin"
  description = "Resource my_rds property username"
}

variable "my_rds_deletion_protection" {
  type = bool
  default = true
  description = "Resource my_rds property deletion_protection"
}

variable "my_rds_allocated_storage" {
  type = number
  default = 20
  description = "Resource my_rds property allocated_storage"
}

variable "my_rds_instance_class" {
  type = string
  default = "db.t3.micro"
  description = "Resource my_rds property instance_class"
}

variable "my_rds_password" {
  type = string
  default = "securepassword123"
  description = "Resource my_rds property password"
}

variable "my_rds_db_subnet_group_name" {
  type = string
  default = "${aws_db_subnet_group.rds_subnet_group.name}"
  description = "Resource my_rds property db_subnet_group_name"
}

variable "my_rds_vpc_security_group_ids" {
  type = list(string)
  default = ["${aws_security_group.rds_sg.id}"]
  description = "Resource my_rds property vpc_security_group_ids"
}

variable "my_rds_storage_encrypted" {
  type = bool
  default = true
  description = "Resource my_rds property storage_encrypted"
}

variable "my_rds_skip_final_snapshot" {
  type = bool
  default = true
  description = "Resource my_rds property skip_final_snapshot"
}

variable "my_rds_backup_retention_period" {
  type = number
  default = 7
  description = "Resource my_rds property backup_retention_period"
}

variable "rds_subnet_group_name" {
  type = string
  default = "rds-subnet-group"
  description = "Resource rds_subnet_group property name"
}

variable "rds_subnet_group_subnet_ids" {
  type = list(string)
  default = ["${aws_subnet.private_subnet.id}"]
  description = "Resource rds_subnet_group property subnet_ids"
}

variable "rds_subnet_group_tags" {
  type = object({ "Name" = string })
  default = {
  Name = "RDS Subnet Group"
}
  description = "Resource rds_subnet_group property tags"
}

variable "my_bucket_force_destroy" {
  type = bool
  default = true
  description = "Resource my_bucket property force_destroy"
}

variable "my_bucket_block_public_acls" {
  type = bool
  default = true
  description = "Resource my_bucket property block_public_acls"
}

variable "my_bucket_block_public_policy" {
  type = bool
  default = true
  description = "Resource my_bucket property block_public_policy"
}

variable "my_bucket_ignore_public_acls" {
  type = bool
  default = true
  description = "Resource my_bucket property ignore_public_acls"
}

variable "my_bucket_restrict_public_buckets" {
  type = bool
  default = true
  description = "Resource my_bucket property restrict_public_buckets"
}

variable "my_bucket_bucket" {
  type = string
  default = "gdpr-compliant-data-store"
  description = "Resource my_bucket property bucket"
}

variable "my_bucket_acl" {
  type = string
  default = "private"
  description = "Resource my_bucket property acl"
}

variable "my_bucket_server_side_encryption_configuration" {
  type = object({ "rule" = object({ "apply_server_side_encryption_by_default" = object({ "sse_algorithm" = string }) }) })
  default = {
  rule = {
  apply_server_side_encryption_by_default = {
  sse_algorithm = "AES256"
}
}
}
  description = "Resource my_bucket property server_side_encryption_configuration"
}

variable "my_bucket_versioning" {
  type = object({ "enabled" = bool })
  default = {
  enabled = true
}
  description = "Resource my_bucket property versioning"
}

variable "my_bucket_logging" {
  type = object({ "target_bucket" = string, "target_prefix" = string })
  default = {
  target_bucket = "gdpr-compliant-data-store"
  target_prefix = "logs/"
}
  description = "Resource my_bucket property logging"
}

