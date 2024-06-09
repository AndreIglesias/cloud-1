# Ansible Playbooks for Docker Webapp Deployment

This repository contains Ansible playbooks to set up, deploy, and manage a Docker-based web application on a WordPress server.

## Requirements

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Ansible inventory configured with the `wordpress` host
- SSH access to the `wordpress` server with sudo privileges

## Inventory Configuration

Ensure your inventory.ini file is properly configured to include the wordpress host. Here is an example configuration:

```ini
[wordpress]
ip_server ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/cloud-key.pem
```

This configuration specifies the target host and the necessary SSH credentials for Ansible to connect.


## Playbooks Overview

### Install Docker and Docker Compose

This playbook installs Docker and Docker Compose on the target host, enables and starts the Docker service, and copies the Docker web application files to the target host.

```yaml
# Install Docker and Docker Compose
- name: Install Docker
  hosts: wordpress
  become: yes
  tasks:
    - name: Install Docker dependencies
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - apt-transport-https
        - ca-certificates
        - curl
        - gnupg
        - lsb-release
        - make

    - name: Add Docker's official GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker repository
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable
        state: present

    - name: Install Docker
      apt:
        name: docker-ce
        state: present

    - name: Create docker group
      group:
        name: docker
        state: present

    - name: Add user to docker group
      user:
        name: ubuntu
        groups: docker
        append: yes

# Enable and start Docker service
- name: Manage Docker Service
  hosts: wordpress
  become: yes
  tasks:
    - name: Start Docker Service
      service:
        name: docker
        state: started
        enabled: yes

# Copy the docker webapp
- name: Copy the docker webapp
  hosts: wordpress
  become: yes
  tasks:
    - name: Copy webapp files
      copy:
        src: ../docker-webapp/
        dest: /home/ubuntu/webapp/
```

### Deploy Docker Compose Webapp

This playbook deploys the web application using Docker Compose.

```yaml
# Deploy Docker Compose webapp
- name: Deploy Webapp with Docker Compose
  hosts: wordpress
  become: yes
  tasks:
    - name: Docker compose up the webapp
      command: make
      args:
        chdir: /home/ubuntu/webapp/
      async: 3600   # Set timeout to 1 hour
      poll: 5       # Poll every 5 seconds for status
      register: make_result

    - name: Show make output
      debug:
        msg: "{{ item }}"
      loop: "{{ make_result.stdout_lines }}"
```

### Destroy Docker Compose Webapp

This playbook destroys the web application using Docker Compose.

```yaml
# Destroy Docker Compose webapp
- name: Destroy Webapp with Docker Compose
  hosts: wordpress
  become: yes
  tasks:
    - name: Docker compose down the webapp
      command: make rm
      args:
        chdir: /home/ubuntu/webapp/
      async: 3600   # Set timeout to 1 hour
      poll: 5       # Poll every 5 seconds for status
      register: make_result

    - name: Show make output
      debug:
        msg: "{{ item }}"
      loop: "{{ make_result.stdout_lines }}"
```

## Usage

### Step 1: Setup the server's environment

Run the playbook to setup the environment:

```sh
ansible-playbook -i inventory.ini setup.yml
```

### Step 4: Deploy the Docker Compose Webapp

Run the playbook to deploy the web application using Docker Compose:

```sh
ansible-playbook -i inventory.ini deploy.yml
```

### Step 5: Destroy the Docker Compose Webapp

Run the playbook to destroy the web application using Docker Compose:

```sh
ansible-playbook -i inventory.ini destroy.yml
```

## Notes

- Ensure that your Ansible inventory is properly configured to include the `wordpress` host.
- Modify the playbooks as needed to fit your specific environment and requirements.
