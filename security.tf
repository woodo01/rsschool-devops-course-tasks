resource "aws_network_acl" "allow_http" {
  vpc_id     = aws_vpc.root.id
  subnet_ids = [aws_subnet.public_subnets[0].id]

  egress {
    protocol  = "tcp"
    rule_no   = 200
    action    = "allow"
    cidr_block = "10.0.0.0/22"
    from_port = 80
    to_port   = 80
  }

  ingress {
    protocol  = "tcp"
    rule_no   = 100
    action    = "allow"
    cidr_block = "10.0.0.0/22"
    from_port = 80
    to_port   = 80
  }

  tags = {
    Name = "Allow http"
  }
}

resource "aws_network_acl" "allow_https" {
  vpc_id     = aws_vpc.root.id
  subnet_ids = [aws_subnet.public_subnets[0].id]
  egress {
    protocol  = "tcp"
    rule_no   = 200
    action    = "allow"
    cidr_block = "10.0.0.0/22"
    from_port = 443
    to_port   = 443
  }

  ingress {
    protocol  = "tcp"
    rule_no   = 100
    action    = "allow"
    cidr_block = "10.0.0.0/22"
    from_port = 443
    to_port   = 443
  }

  tags = {
    Name = "Allow https"
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.root.id
  name        = "allow_ssh"
  description = "SSH traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "allow_icmp" {
  vpc_id      = aws_vpc.root.id
  name        = "allow_icmp"
  description = "Security group allowing ICMP (ping) traffic"
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow ICMP"
  }
}

resource "aws_security_group" "http" {
  vpc_id      = aws_vpc.root.id
  name        = "http_security_group"
  description = "Controls access to http/80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
