output "asg_sg_id" {
  value = aws_security_group.main.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}
