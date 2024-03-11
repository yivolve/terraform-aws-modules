resource "aws_iam_role" "ec2_role" {
  name = "${var.name}-role"
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Effect" = "Allow",
          "Action" = [
            "sts:AssumeRole"
          ],
          "Principal" = {
            "Service" = [
              "ec2.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  count      = local.policy_count
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::${var.aws_policy_names[count.index]}"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.instance_name}-instance_profile"
  role = aws_iam_role.ec2_role.name
  provisioner "local-exec" {
    command = "echo 'Sleeps for 30 seconds to propagate the aws IAM instance profile (This a Terraform bug, see https://github.com/terraform-providers/terraform-provider-aws/issues/838)' && sleep 30"
  }
  tags = merge(
    { "Name" = "${var.instance_name}-instance_profile" },
  )
}
