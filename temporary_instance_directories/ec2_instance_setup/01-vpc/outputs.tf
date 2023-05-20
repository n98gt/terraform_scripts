# output "test-server_public_ip" {
#   value       = aws_instance.test-server.public_ip
#   description = "IP for ssh connection"
# }

# output "test-server_private_ip" {
#   value = aws_instance.test-server.private_ip
# }


output "vpc_id" {
  value = aws_vpc.vpc_for_test-server.id
}

output "subnet_id" {
  value = aws_subnet.subnet_for_test-server.id
}
