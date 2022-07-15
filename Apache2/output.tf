output "public_ip_addr" {
  value = aws_instance.VIJAY-TERRAFORM.public_ip
}

output "elastic_ip_addr" {
  value = aws_eip.my-eip.public_ip
}

data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

locals {
    account_id = data.aws_caller_identity.current.account_id
}
