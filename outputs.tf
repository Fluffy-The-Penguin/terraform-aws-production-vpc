output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}
output "web_security_group_id" {
  description = "ID of the Web Security Group"
  value       = aws_security_group.web_sg.id
}

output "db_security_group_id" {
  description = "ID of the Database Security Group"
  value       = aws_security_group.db_sg.id
}
