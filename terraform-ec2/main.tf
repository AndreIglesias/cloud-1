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
      "sudo apt-get install -y emacs-nox"
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
