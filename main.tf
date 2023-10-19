
# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region 
}


# launch instance in VPC

 #create instance
resource "aws_instance" "TF_Activity" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = var.subnet_id 
  vpc_security_group_ids = [var.security_group_id]

  #user_data = ""

  tags = {
    Name : "TF_Activity"
    vpc: "Kura-VPC"
    az : "${var.region}a"
  }
}


output "tf_activity_server" {
  value = aws_instance.TF_Activity.public_ip
}
