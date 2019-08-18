variable "key_name" {
   default = "web-app"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "amis" {
    description = "AMIs by region"
    default = "ami-035b3c7efe6d061d5"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "public_subnet1_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.64.0/20"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}
