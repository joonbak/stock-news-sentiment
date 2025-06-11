variable "instance_name" {
    type = string
    default = "MyNewInstance"
}

variable "aws_region" {
    type = string
    default = "ap-southeast-2"
}

variable "ec2_instance_type" {
    type = string
    default = "t2.micro"
}

variable "aws_ami_id" {
    type = string
    default = "ami-07b7cae50f732535f"
}

variable "domain_name" {
    type = string
    default = "example.com"
}
variable "record_name" {
    type = string
    default = "www"
    description = "Subdomain Name"
}

variable "key_pair_name" {
    type = string
    default = "sshkey"
}

variable "public_key_path" {
    type = string
    default = "~/.ssh/sshkey.pub"
}

variable "port" {
    type = number
    default = 22
}

variable "cidr_ipv4" {
    type = string
    default = "0.0.0.0/0"
}