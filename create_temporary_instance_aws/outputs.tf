output "test-server_public_ip" {
  value       = aws_instance.test-server.public_ip
  description = "IP for ssh connection"
}

output "test-server_private_ip" {
  value = aws_instance.test-server.private_ip
}

output "elastic_ip_id" {
  value = data.aws_eip.existing_eip.id
}

output "elastic_ip_public_ip" {
  value = data.aws_eip.existing_eip.public_ip
}
