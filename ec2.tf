resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ansible"
  public_key = file("terra-key-ansible.pub")
  tags = {
   // Environment = var.env
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "example" {
  provider = aws    
  name = "default-sg"
  vpc_id = aws_default_vpc.default.id

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
}

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
}

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all Outbound traffic"
}
tags = {
    Name = "automate-sg"
}
}

resource "aws_instance" "example" {
 for_each = tomap (
  {
    ec2-micro-Master = "ami-0e5497a77ef21b5ac", #ubuntu
    ec2-micro-1 = "ami-0e5497a77ef21b5ac", #ubuntu
    ec2-micro-2 = "ami-008f67e1a087a7449", #redhat
    ec2-micro-3 = "ami-06475e8f54266e38e" #amazon linux
  
  }
 ) 
depends_on = [ aws_key_pair.my_key, aws_security_group.example]

 key_name = aws_key_pair.my_key.key_name
 security_groups = [ aws_security_group.example.name ]
 instance_type = "t3.micro"
 ami = each.value

 root_block_device {
    volume_size =10
    volume_type = "gp3"
 }
 tags = {
   Name = each.key
   
 }
}
