# terraform and ansible test

Use terraform to create an infrastracture, two ec2 instances and one LB. 
After all done outputs IP addresses of the EC2 instances

open inventori.ini and edit IP address, username and key if needed

run command > 
ansible-playbook -i inventory.ini setup_apache.yml

ansamble only works in linux
