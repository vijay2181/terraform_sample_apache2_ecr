#####################################
## Virtual Machine Module - Output ##
#####################################

output "vijay_server_instance_id" {
  value = aws_instance.vijay-server.*.id
}

output "vijay_server_instance_public_dns" {
  value = aws_instance.vijay-server.*.public_dns
}

output "vijay_server_instance_private_ip" {
  value = aws_instance.vijay-server.*.private_ip
}

output "vijay_server_instance_public_ip" {
  value = aws_instance.vijay-server.*.public_ip
}
