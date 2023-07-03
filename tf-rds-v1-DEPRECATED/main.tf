provider "aws" {
  region  = var.region
  profile = var.profile
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  # default = true
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}


# data "aws_security_group" "default" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "default"
# }

resource "aws_security_group" "default" {
  name        = "giessdenkiez-terraform_rds_sg-${var.env_suffix}"
  description = "giessdenkiez RDS"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # this is okay for our development setup
    # in production the EB only should have access to the SG
    # can be done using its securoty group
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name    = "terraform-rds-security-group"
    project = "giessdenkiez"
    type    = "rds security group"
  }
}


#####
# DB
#####
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "giessdenkiez-${var.env_suffix}"

  engine            = "postgres"
  engine_version    = "11.2"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = var.pg_name

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.pg_user

  password = var.pg_password
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Project     = "giessdenkiez"
    Environment = "dev"
  }

  publicly_accessible = true

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.all.ids

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "giessdenkiezdb"

  # Database Deletion Protection
  deletion_protection = false
}
