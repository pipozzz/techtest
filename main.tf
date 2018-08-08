provider "aws" {
  region = "us-east-1"
}

variable "ssh_key" {
  default = "test"
}

resource "aws_cloudformation_stack" "techtest" {
  name = "techtest-stack"


  parameters {
    SSHKey = "${var.ssh_key}"
  }

  template_body = "${file("${path.module}/templates/vpc.yaml")}"
}
