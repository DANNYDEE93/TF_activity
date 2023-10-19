# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

#connect to currently existing vpc named "Kura-VPC"
resource "aws_vpc" "Kura-VPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
}



 #create instance and connect to Kura-VPC
resource "aws_instance" "TF_Activity" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true

  #user_data = ""

  tags = {
    Name : "TF_Activity"
    vpc : "Kura-VPC"
    az : "${var.region}a"
  }
}

#print out instance ip address
output "tf_activity_server" {
  value = aws_instance.TF_Activity.public_ip
}
