output "test-server_public_ip" {
  value = aws_instance.test-server.public_ip
}

output "test-server_private_ip" {
  value = aws_instance.test-server.private_ip
}