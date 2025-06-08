provider "aws" {
    profile = "default"
    region = var.aws_region
} 

resource "aws_instance" "app_server" {
    ami = var.aws_ami_id
    instance_type = var.ec2_instance_type
    key_name = aws_key_pair.aws_key.key_name

    tags = {
        Name = var.instance_name
    }
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