resource "aws_security_group" "producer" {
  # checkov:skip=CKV_AWS_23: "Ensure every security group and rule has a description"
  # checkov:skip=CKV_AWS_382: "Ensure no security groups allow egress from 0.0.0.0:0 to port -1"
  # checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
  name        = "${local._deployment}-producer"
  description = "Security group for the ${local._deployment} producer"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
