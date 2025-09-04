module "producer" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/stormreply/terraform-build-controller.git"
  instance_type   = "m6.xlarge"
  policies        = local.producer_policies
  security_groups = [aws_security_group.web_log_producer_sg.name]

  user_data_base64 = base64encode(trimspace(data.cloudinit_config.controller.rendered))

  user_data = <<-EOF
  EOF

  tags = {
    Name = "${var.deployment.name}-producer"
  }
}
