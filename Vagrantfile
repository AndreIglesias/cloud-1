Vagrant.configure("2") do |config|
    config.vm.synced_folder ".", "/vagrant"
    config.vm.box = "ubuntu/jammy64"
    config.vm.box_version = "20230828.0.0"
    config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 2
      end
  
    config.vm.provision "shell", inline: <<-SHELL
      # Update packages and install dependencies
      sudo apt-get update
      sudo apt-get install -y wget unzip software-properties-common
  
      # Ansible
      sudo apt-add-repository --yes --update ppa:ansible/ansible
      sudo apt-get install -y ansible
  
      # Terraform
      TERRAFORM_VERSION="1.5.0"  # Ajusta la versión según tus necesidades
      wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
      unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
      sudo mv terraform /usr/local/bin/
      rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
  
      # CLI de AWS
      sudo apt-get install -y awscli

    SHELL
  end