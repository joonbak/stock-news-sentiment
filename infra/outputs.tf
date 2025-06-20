output "instance_id" {
   description = "ID of the EC2 instance"
   value = aws_instance.app_server.id 
}

output "instance_public_ip" {
   description = "Public IP address of the EC2 instance"
   value = aws_instance.app_server.public_ip
}

output "instance_elastic_ip" {
   description = "Elastic IP address associated with the EC2 instance"
   value = aws_eip.app_server_eip.public_ip
}