provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0a7f1556c36aaf776"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_rules.id,aws_security_group.ssh_rules.id]
  }

resource "aws_instance" "LamoMama" {
  ami           = "ami-0a7f1556c36aaf776"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_rules.id,aws_security_group.web_rules.id]
}

resource "aws_security_group" "web_rules" {
  name = "websg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_rules" {
  name = "sshsg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb-YoMama" {
  name = "elb-YoMama"
  availability_zones = ["us-east-1a","us-east-1b"]

  listener {
    instance_port      =80
    instance_protocol  ="http"
    lb_port            =80
    lb_protocol        ="http"
  }
instances           =["${aws_instance.example.id}","${aws_instance.LamoMama.id}"]
}
