module "producer" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source                 = "git::https://github.com/stormreply/terraform-build-controller.git"
  name                   = "${local._name_tag}-producer"
  instance_type          = "m6i.xlarge"
  policies               = local.producer_policies
  user_data_base64       = base64encode(trimspace(data.cloudinit_config.controller.rendered))
  vpc_security_group_ids = [aws_security_group.producer.id]
}
