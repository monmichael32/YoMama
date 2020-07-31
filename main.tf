provider "aws" {
 region = "us-east-1"
}
resource "aws_vpc" "vpc" {
 cidr_block = "10.0.0.0/16"
 enable_dns_support  = true
 enable_dns_hostnames = true
 tags = {
  Environment = "production"
 }
}
resource "aws_key_pair" "deployer" {
 key_name  = "deployer-key"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9+sRnqO1shgNfMdnWy/usEjE/Y794EnAQXbX2NJNWEw/F5YlWYM/LqjIIUvkNb6f9UyD4uUV8zu8Z3ss/Y3iugCN3Jp1PycUE2wg8Mco6rNXaJXjJS982/TsdP8JZ7M6Pj327aiG1eqjZeCmc89/eBHmWkxjbQkOOpanCnO13r5ohm8cumkA/J+WgdGdLmf2W2CjjdoAKw2HvuuzI1ebr4w6QF2mmGukrNrlXX4ENOLGV+0RZ1nnEgT0kjAqcDDQYnURYrBNGLLpPzjO6kW8o+XxTPwEr9wPePD1DRXGoY8j5cnpVwYbMupJ6N2HNVyZaIzJ606bPph3enQy1+dxT monicamichael@Monicas-Air"
}
resource "aws_instance" "example" {
 ami      = "ami-0a7f1556c36aaf776"
 instance_type = "t2.micro"
 vpc_security_group_ids = [aws_security_group.web_rules.id,aws_security_group.ssh_rules.id]
 key_name = "deployer-key"
 }
resource "aws_instance" "LamoMama" {
 ami      = "ami-0a7f1556c36aaf776"
 instance_type = "t2.micro"
 vpc_security_group_ids = [aws_security_group.ssh_rules.id,aws_security_group.web_rules.id]
key_name = "deployer-key"
}
resource "aws_security_group" "web_rules" {
 name = "websg"
 egress {
  to_port=0
  protocol=-1
  from_port=0
 }
 ingress {
  from_port  = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_security_group" "ssh_rules" {
 name = "sshsg"
 ingress {
  from_port  = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_elb" "elb-YoMama" {
 name = "elb-YoMama"
 availability_zones = ["us-east-1a","us-east-1b"]
 listener {
  instance_port   =80
  instance_protocol ="http"
  lb_port      =80
  lb_protocol    ="http"
 }
instances =["${aws_instance.example.id}","${aws_instance.LamoMama.id}"]
}

#Breaking here?
#data "aws_internet_gateway" "default" {
# filter {
#  name  = "attachment.vpc-id"
#  values = ["${"aws_vpc.vpc.id"}"]
# }
#}

resource "aws_internet_gateway" "igw" {
 vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "subnet_public" {
 vpc_id = "${aws_vpc.vpc.id}"
 cidr_block = "10.0.0.0/16"
 map_public_ip_on_launch = "true"
 availability_zone = "us-east-1a"
}

resource "aws_route_table" "rtb_public" {
 vpc_id = "${aws_vpc.vpc.id}"
route {
   cidr_block = "0.0.0.0/0"
   gateway_id = "${aws_internet_gateway.igw.id}"
 }
}

resource "aws_route_table_association" "rta_subnet_public" {
 subnet_id   = "${aws_subnet.subnet_public.id}"
 route_table_id = "${aws_route_table.rtb_public.id}"
}
