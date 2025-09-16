data "cloudinit_config" "controller" {

  # see https://discuss.hashicorp.com/t/terraform-template-cloudinit-config-multiple-part-execution-order-is-wrong/16962/3
  gzip          = false
  base64_encode = false

  part {
    filename     = "01-stop-ssm-agent.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/userdata/01-stop-ssm-agent.sh")
  }

  part {
    filename     = "02-install-kinesis-agent.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/02-install-kinesis-agent.sh", {
      deployment_name = var.deployment.name
    })
  }

  part {
    filename     = "03-install-apache-fake-log-gen.py"
    content_type = "text/cloud-config"
    content      = <<-EOT
      #cloud-config
      write_files:
        - path: /apache-fake-log-gen.py
          permissions: '0644'
          content: file("${path.module}/userdata/03-apache-fake-log-gen.py")
    EOT
  }
  part {
    filename     = "04-start-apache-fake-log-gen.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/userdata/03-install-apache-fake-log-gen.sh")
  }

  part {
    filename     = "05-start-ssm-agent.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/userdata/04-start-ssm-agent.sh")
  }
}
