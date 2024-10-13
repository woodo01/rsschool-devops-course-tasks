resource "aws_instance" "bastion_host" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "Bastion Host"
  }
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_key" {
  key_name   = "SSH Private Key to connect to EC2 instances"
  public_key = tls_private_key.my_key.public_key_openssh
}
