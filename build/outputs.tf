output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "public_route_table_assoc_id" {
  value = aws_route_table_association.public_route_table_assoc.id
}

output "nat_gateway_eip_id" {
  value = aws_eip.nat_gateway_eip.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "private_route_table_assoc_id" {
  value = aws_route_table_association.private_route_table_assoc.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "my_instance_id" {
  value = aws_instance.my_instance.id
}

output "my_rds_id" {
  value = aws_db_instance.my_rds.id
}

output "rds_subnet_group_id" {
  value = aws_db_subnet_group.rds_subnet_group.id
}

output "my_bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

