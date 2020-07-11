#!/bin/bash
# Bug do cloud-init vs ansible requer que a variável HOME esteja explicitamente setada.
# Ver https://github.com/ansible/ansible/issues/31617#issuecomment-337029203
export HOME=/root
cd /tmp
apt-get update && 
apt-get install -y python ansible unzip awscli postgresql-client
chmod 400 /home/ubuntu/.ssh/id_rsa
aws s3 cp s3://ansibleappuni7nodeapp/ansible/ansible.zip ansible.zip
unzip ansible.zip
sudo ansible-playbook -vvv -i hosts_app provisioning.yml
