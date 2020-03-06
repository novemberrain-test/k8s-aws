module "kubernetes" {
  # source = "scholzj/kubernetes/aws"
    source = "../"
  aws_region           = "us-east-1"
  cluster_name         = "aws-kubernetes"
  master_instance_type = "t2.medium"
  worker_instance_type = "t2.medium"
  ssh_public_key       = "~/.ssh/id_rsa.pub"
  ssh_access_cidr      = ["0.0.0.0/0"]
  api_access_cidr      = ["0.0.0.0/0"]
  min_worker_count     = 2
  max_worker_count     = 2
  hosted_zone          = "learningforever.tk"
  hosted_zone_private  = false

  master_subnet_id = "subnet-0687b0d3798afae82"
  worker_subnet_ids = [
    "subnet-01adde433d9f3a20d",
    "subnet-01adde433d9f3a20d",
  ]

  # Tags
  tags = {
    Application = "AWS-Kubernetes"
  }

  # Tags in a different format for Auto Scaling Group
  tags2 = [
    {
      key                 = "Application"
      value               = "AWS-Kubernetes"
      propagate_at_launch = true
    },
  ]

  addons = [
    "https://raw.githubusercontent.com/scholzj/terraform-aws-kubernetes/master/addons/storage-class.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-kubernetes/master/addons/metrics-server.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-kubernetes/master/addons/dashboard.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-kubernetes/master/addons/external-dns.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-kubernetes/master/addons/autoscaler.yaml",
  ]
}

output "public_ip" {
  description = "Cluster IP address"
  value       = module.kubernetes.public_ip
}
