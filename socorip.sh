#!/bin/bash

helm_version='3'
current_user=$1
persistence_volume=$([ "$2" ] && echo "true" || echo "false")
ingress=$([ "$3" ] && echo "true" || echo "false")
ingress_hostname='jenkins.learningforever.tk'
terraform_deploy_repo='examples'
terraform_repo="/home/${current_user}/terraform-aws-kubernetes"
ip_output='public_ip'

#get ip master node
cd "${terraform_repo}"/"${terraform_deploy_repo}" && master_ip=$(terraform output ${ip_output})
cd $HOME

#get kubeconfig from master node
scp centos@${master_ip}:/home/centos/kubeconfig /home/${current_user}

#export kubeconfig
export KUBECONFIG=/home/${current_user}/kubeconfig

#install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-$helm_version && chmod 700 get_helm.sh && ./get_helm.sh || exit 1

# helm add&update repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com && helm repo update

#install jenkins using helm
helm install jenkins-master-bootrap stable/jenkins --set persistence.enabled=${persistence_volume} --set master.ingress.enabled=${ingress} --set master.ingress.hostName=${ingress_hostname} --set master.serviceType=NodePort
