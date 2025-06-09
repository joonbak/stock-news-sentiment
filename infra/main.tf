provider "aws" {
    profile = "default"
    region = var.aws_region
} 

data "aws_vpc" "main" {
    default = true
}

resource "aws_instance" "app_server" {
    ami = var.aws_ami_id
    instance_type = var.ec2_instance_type
    key_name = aws_key_pair.aws_key.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]

    tags = {
        Name = var.instance_name
    }

    user_data = file("startup.sh")
}

resource "aws_security_group" "allow_ssh_http_https" {
  name = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS inbound traffic"
  vpc_id = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh_http_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ssh_http_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_ssh_http_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


resource "aws_key_pair" "aws_key" {
    key_name   = var.key_pair_name
    public_key = file(var.public_key_path)
}

resource "aws_eip" "app_server_eip" {
    instance = aws_instance.app_server.id
    domain = "vpc"
}

resource "aws_route53_zone" "hosted_zone" {
    name = var.domain_name
}

resource "aws_route53_record" "app_domain" {
    zone_id = aws_route53_zone.hosted_zone.zone_id
    name = var.record_name
    type = "A"
    ttl = 300
    records = [aws_eip.app_server_eip.public_ip]
}