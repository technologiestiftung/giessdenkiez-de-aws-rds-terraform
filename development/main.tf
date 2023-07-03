terraform {
  backend "remote" {
    organization = "technologiestiftung"
    workspaces {
      name = "giessdenkiez-de-rds-v2"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

locals {
  name    = "giessdenkiez-de-v2"
  env     = "dev"
  region  = "eu-central-1"
  profile = "tsberlin"
  tags = {
    Project     = "giessdenkiez-de"
    Environment = "dev"
  }
}

################################################################################
# Supporting Resources
################################################################################



#############################################################
# Data sources to get VPC and default security group details
#############################################################
data "aws_vpc" "public" {
  id = var.vpc_id
}


data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.public.id
}

# data "aws_security_group" "default" {
#   name   = "default"
#   vpc_id = data.aws_vpc.default.id
# }


# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 2"

#   name = "${local.name}-${local.env}"
#   cidr = "10.99.0.0/18"

#   azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
#   public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
#   private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
#   database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

#   create_database_subnet_group = true

#   tags = local.tags
# }

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = "${local.name}-${local.env}"
  description = "giessdenkiez-de rds v2 security group"
  vpc_id      = data.aws_vpc.public.id

  # ingress
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  ingress_rules       = ["postgresql-tcp"]
  egress_rules        = ["postgresql-tcp"]
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 5432
  #     to_port     = 5432
  #     protocol    = "tcp"
  #     description = "PostgreSQL access from within VPC"
  #     cidr_blocks = ["0.0.0.0/0", module.vpc.vpc_cidr_block]
  #   },
  # ]

  tags = local.tags
}

################################################################################
# RDS Module
################################################################################

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.name}-${local.env}"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t2.small"

  create_db_option_group    = false
  create_db_parameter_group = false

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false
  publicly_accessible   = true

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name     = var.dbname
  username = var.username
  password = var.password
  port     = 5432

  multi_az   = true
  subnet_ids = data.aws_subnet_ids.all.ids
  # subnet_ids             = data.aws_vpc.default.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = false
  monitoring_interval                   = 0

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}

