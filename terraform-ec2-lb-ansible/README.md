Terraform and Ansible Example
This guide provides instructions on using Terraform to create an infrastructure that includes two EC2 instances and one Load Balancer on AWS. After the infrastructure setup is complete, the guide will show you how to use Ansible to deploy configurations to these instances.

Getting Started
Before you begin, ensure you have the following prerequisites:

An AWS account
Terraform installed on your machine
Ansible installed on your machine (Note: Ansible is only compatible with Linux environments)
Proper AWS credentials configured in your environment
Steps to Deploy Using Terraform
Initialize Terraform
bash
Copy code
terraform init
This command initializes a working directory containing Terraform configuration files.
Plan Your Infrastructure
bash
Copy code
terraform plan
This command shows you what Terraform will do without making any changes to your actual resources.
Apply Your Configuration
bash
Copy code
terraform apply
Confirm the action by typing yes when prompted. This step will create the infrastructure and output the IP addresses of the EC2 instances.
Configure Ansible
Edit Your Inventory FileOpen the inventory.ini file and update it with the IP addresses, usernames, and SSH keys as required:
ini
Copy code
# inventory.ini
[servers]
server1 ansible_host=YOUR_INSTANCE_IP ansible_user=YOUR_USERNAME ansible_ssh_private_key_file=YOUR_PRIVATE_KEY_PATH
server2 ansible_host=YOUR_INSTANCE_IP ansible_user=YOUR_USERNAME ansible_ssh_private_key_file=YOUR_PRIVATE_KEY_PATH
Run the Ansible Playbook
bash
Copy code
ansible-playbook -i inventory.ini setup_apache.yml
This command executes the playbook which configures Apache on the EC2 instances defined in your inventory.
Important Notes
Ensure that the security group associated with your EC2 instances allows inbound traffic on port 80 for HTTP and port 22 for SSH.
Ansible commands and configurations are intended to be run from a Linux environment.