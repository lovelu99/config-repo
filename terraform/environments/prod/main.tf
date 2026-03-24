

module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_count    = var.nat_gateway_count

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"

  }
}

module "eks" {
  source = "../../modules/eks"
  aws_region              = var.aws_region
  project_name            = var.project_name
  environment             = var.environment
  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  #vpc_cidr                = module.vpc.vpc_cidr
  bastion_sg_id           = module.bastion.security_group_id

  endpoint_private_access = true
  endpoint_public_access  = true

  node_group_name = var.node_group_name
  instance_types  = var.instance_types
  capacity_type   = "ON_DEMAND"
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  disk_size       = 20

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "bastion" {
  source = "../../modules/ec2"

  name                        = "${var.project_name}-${var.environment}-bastion"
  ami_id                      = var.ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  allowed_ssh_cidrs           = [var.my_ip_cidr]

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Role        = "bastion"
    ManagedBy   = "Terraform"
  }
}

module "jenkins" {
  source = "../../modules/ec2"

  name                        = "${var.project_name}-${var.environment}-jenkins"
  ami_id                      = var.ami_id
  instance_type               = var.jenkins_instance_type
  subnet_id                   = module.vpc.private_subnet_ids[0]
  #subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  #associate_public_ip_address = true
  associate_public_ip_address = false
  key_name                    = var.key_name
  allowed_ssh_cidrs           = [var.vpc_cidr]

  ingress_rules = [
    {
      description = "Jenkins UI"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      #cidr_blocks = [var.allow_all_ip]
      cidr_blocks = [var.vpc_cidr]
    }
  ]

  root_volume_size = 15

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Role        = "jenkins"
    ManagedBy   = "Terraform"
  }
}

module "sonarqube" {
  source = "../../modules/ec2"

  name                        = "${var.project_name}-${var.environment}-sonarqube"
  ami_id                      = var.ami_id
  instance_type               = var.sonarqube_instance_type
  subnet_id                   = module.vpc.private_subnet_ids[1]
  #subnet_id                   = module.vpc.public_subnet_ids[1]
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  #associate_public_ip_address = true
  key_name                    = var.key_name
  allowed_ssh_cidrs           = [var.vpc_cidr]

  ingress_rules = [
    {
      description = "SonarQube UI"
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      #cidr_blocks = [var.allow_all_ip]
      cidr_blocks = [var.vpc_cidr]
      
    }
  ]

  root_volume_size = 15

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Role        = "sonarqube"
    ManagedBy   = "Terraform"
  }
}
