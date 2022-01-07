# output "test-server_public_ip" {
#   value       = aws_instance.test-server.public_ip
#   description = "IP for ssh connection"
# }

# output "test-server_private_ip" {
#   value = aws_instance.test-server.private_ip
# }

output "sec_group_id" {
  value = aws_security_group.security-group_for_test-server.id
}
