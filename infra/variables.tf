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
    default = "jbfolio.com"
}
variable "record_name" {
    type = string
    default = "sns"
    description = "Subdomain Name"
}