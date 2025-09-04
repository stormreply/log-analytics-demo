resource "aws_security_group" "producer" {
  name        = "${var.deployment.name}-producer"
  description = "Security group for the ${var.deployment.name} producer"
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
