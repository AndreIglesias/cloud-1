# Automated Deployment of a website infrastructure

![alt text](terraform.png)
![alt text](ansible.png)
![alt text](aws.png)

## Project Overview

This project focuses on the automated deployment of a web server and the necessary Docker infrastructure on a remote server. The goal is to deploy a site, such as a WordPress blog, with each process running in its container. Automation is a key component of this project, and tools like Ansible are suggested to facilitate this process.

## Features

- Automated deployment of a WordPress site.
- Containers for each process (WordPress, PHPmyadmin, database, etc.).
- Persistence of data across server reboots.
- Secure and limited public access.
- TLS support for secure connections.
- Deployment on multiple servers in parallel.

## Platform Choice

This project uses AWS EC2 instances to host the necessary infrastructure. Ensure you use the free tier resources efficiently to minimize costs.

## Prerequisites

- An AWS account with access to EC2.
- An EC2 instance running Ubuntu 20.04 LTS.
- Docker and Docker Compose installed on the instance.
- Ansible or an equivalent automation tool.

## Setup

1. **Clone the Repository**
   ```sh
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. **Set Up the EC2 Instance**
   - Ensure your SSH key is added to your AWS EC2 instance.
   - Connect to your instance via SSH:
     ```sh
     ssh -i your-key.pem ubuntu@your-ec2-public-dns
     ```

3. **Install Docker and Docker Compose**
   - Follow the [Docker installation guide](https://docs.docker.com/engine/install/ubuntu/).
   - Install Docker Compose:
     ```sh
     sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     sudo chmod +x /usr/local/bin/docker-compose
     ```

4. **Run the Deployment Script**
   - Modify the `inventory.ini` file with your EC2 instance details.
   - Run the Ansible playbook:
     ```sh
     ansible-playbook -i inventory.ini deploy.yml
     ```

## Security Considerations

- Ensure public access to your server is restricted and secure.
- Do not expose the database directly to the internet.
- Use TLS to secure communications.

## Important Notes

- Monitor your resource usage to avoid exceeding free tier limits and incurring charges.
- Avoid leaving sensitive information like keys or identifiers in public repositories.

## Submission and Evaluation

- Submit your work through your Git repository.
- Ensure all necessary files and folders are correctly named.
- Focus on functionality over aesthetics; a basic WordPress site is sufficient.

## Resources

- [WordPress](https://wordpress.org/)
- [PHPmyadmin](https://www.phpmyadmin.net/)
- [AWS EC2](https://aws.amazon.com/ec2/)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

