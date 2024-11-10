resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.public.id,
  ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "control_node" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.k8s_public_temporal.id,
  ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "K3S Control node"
  }
  user_data = <<-EOF
              #!/bin/bash
              set -e
              hostnamectl set-hostname "master-node"
              sudo apt-get update -y
              sudo apt-get install -y curl apt-transport-https git

              # Install k3s with public IP in TLS SAN
              curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(curl -s 2ip.io)" sh -

              # Wait for k3s to be ready
              while ! kubectl get nodes; do
                echo "Waiting for k3s to be ready..."
                sleep 10
              done

              # Setup kubeconfig
              mkdir -p ~/.kube
              sudo chmod 644 /etc/rancher/k3s/k3s.yaml
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $(id -u):$(id -g) ~/.kube/config

              # Wait for node to be ready
              while [[ $(kubectl get nodes --no-headers 2>/dev/null | grep "Ready" | wc -l) -eq 0 ]]; do
                echo "Waiting for node to be ready..."
                sleep 10
              done

              # Install Helm
              curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
              sudo apt-get update -y
              sudo apt-get install -y helm

              # Clone the WordPress repository
              mkdir -p /home/ubuntu/helm
              sudo chown ubuntu:ubuntu /home/ubuntu/helm
              git clone https://github.com/woodo01/rsschool-aws-devops-simple-wp-app.git /home/ubuntu/helm/wp

              # Wait for the repository to be cloned
              sleep 10

              # Install WordPress using Helm
              helm install app-wordpress /home/ubuntu/helm/wp/wordpress --set wordpress.service.nodePort=32000

              # Ensure the services are running
              kubectl get pods -A
              EOF
}

resource "aws_instance" "agent_node" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.public.id,
    aws_security_group.private.id,
    aws_security_group.k3s.id
  ]
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = "K3S Agent node"
  }
  depends_on = [aws_instance.control_node]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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
