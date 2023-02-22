data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2*kernel*gp2"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

data "aws_key_pair" "this" {
  key_name           = "AlexGKP"
  include_public_key = true
}

resource "aws_security_group" "this" {
  name        = "webserverSecurityGroup"
  description = "WebserverAccess"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "http from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebserverSecurityGroup"
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.az1.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name = data.aws_key_pair.this.key_name

  tags = {
    Name = "MyWebServer"
  }
}

