output "test-spot-server_public_ip" {
  value       = aws_spot_instance_request.test-spot-server.public_ip
  description = "IP for ssh connection"
}

output "test-spot-server_private_ip" {
  value = aws_spot_instance_request.test-spot-server.private_ip
}
