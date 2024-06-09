provider "aws" {
  region = "eu-west-3"
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow SSH and HTTPS traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress_sg"
  }
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0326f9264af7e51e2" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy
  instance_type = "t2.micro"
  key_name      = "cloud-key"

  tags = {
    Name = "WordPress-Server"
  }

  root_block_device {
    volume_size = 8 # GiB
  }

  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo usermod -aG docker ubuntu",
      "newgrp docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/cloud-key.pem")
      host        = aws_instance.wordpress.public_ip
    }
  }
}

output "instance_ip" {
  description = "The public IP of the WordPress server"
  value       = aws_instance.wordpress.public_ip
}
