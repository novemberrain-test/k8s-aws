#!/bin/bash

current_user=$1
terraform_deploy_repo='example'
terraform_repo="/home/${user}/terraform-aws-kubernetes"
ip_output='ip_public'
#get ip master node

cd "${terraform_repo}"/"${terraform_deploy_repo}" && master_ip=$(terraform output ${ip_output})

#get kubeconfig from master node
scp centos@${master_ip}:/home/centos/kubeconfig /home/${current_user}
#export kubeconfig
export KUBECONFIG=/home/${current_user}/kubeconfig ; exit
