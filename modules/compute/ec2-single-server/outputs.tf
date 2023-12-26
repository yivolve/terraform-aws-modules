output "ec2_public_ip" {
  value       = aws_instance.single_ec2_example.public_ip
  description = "The public IP address of the web server"
}

output "ec2_public_dns" {
  value       = aws_instance.single_ec2_example.public_dns
  description = "The public IP address of the web server"
}

output "ec2_security_group_id" {
  value       = aws_security_group.single_ec2_example_sg.id
  description = "The public IP address of the web server"
}

output "ec2_security_group_vpc" {
  value       = aws_security_group.single_ec2_example_sg.vpc_id
  description = "The public IP address of the web server"
}

output "role_names" {
  value       = module.roles_for_ec2.role_names
  description = "The public IP address of the web server"
}
