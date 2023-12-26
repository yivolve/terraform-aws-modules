output "ec2_public_ip" {
  value       = aws_instance.ec_instance.public_ip
  description = "The public IP address of the web server"
}

output "ec2_public_dns" {
  value       = aws_instance.ec_instance.public_dns
  description = "The public IP address of the web server"
}

# output "ec2_security_group_id" {
#   value       = aws_security_group.ec_instance_sg.id
#   description = "The public IP address of the web server"
# }

# output "ec2_security_group_vpc" {
#   value       = aws_security_group.ec_instance_sg.vpc_id
#   description = "The public IP address of the web server"
# }

output "instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_instance_profile.name
  description = "Instance profile name"
}

output "role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "Role name"
}
