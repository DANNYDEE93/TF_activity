# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  #profile = "Admin"
}



resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "tfactivity_vpc"
  }
}

output "vpc_id" {
    value = aws_vpc.main.id
  }



resource "aws_subnet" "PubSubA" {
    vpc_id     = var.vpc_id.id
    availability_zone = "us-east-1a"
    cidr_block = var.public_subnet_cidr
    
      
        //subnet config

  tags = {
    Name = "tfactivity_subnet"
  }
}

# create instance
resource "aws_instance" "TF_Activity" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_group.id
  
  #referring back to subnet within vpc
   subnet_id = var.public_subnet.id  
   associate_public_ip_address = true
   key_name = var.key_name
   
   #user_data = ""

  tags = {
    "Name" : "TF_Activity"
  }

}

# create security groups

resource "aws_security_group" "tfactivitysg" {
  name        = "tfactivitysg"
  description = "open ssh traffic"
  vpc_id = var.vpc_id.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "tfactivitysg"
    "Terraform" : "true"
  }

}

output "instance_ip" {
  value = aws_instance.TF_Activity.public_ip
}
