# giessdenkiez.de DB provisioning

These are some scripts and tools to setup a Postgres DB and provision the needed tables for the [giessdenkiez.de](https://github.com/technologiestiftung/giessdenkiez-de/) project.


## Prerequisites

- Terraform (install using [asdf](https://asdf-vm.com/#/))
- AWS public VPC with public subnets (yes we know. Not best practice. Show us how to improve this)
- Terraform Cloud Account

## Setup

Follow the terraform AWS setup instructions to get your credentials right

```bash
git clone git@github.com:technologiestiftung/giessdenkiez-de-aws-rds-terraform.git
cd giessdenkiez-de-aws-rds-terraform/tf-rds-v2
asdf install
terraform login
terraform init
mv terraform.auto.tfvars.example terraform.auto.tfvars
```
Fill in all the variables in `terraform.auto.tfvars`.
## Usage

```bash
cd tf-rds-v2
terraform apply
```

Now connect to your RDS DB and install Postgis using the script `scripts/enable-postgis-on-aws.sql`

## Dump and Restore

To move your data from an existing DB to a new one do the following. 

Hint!: This workflow uses docker to start a container that has `psql`, `pg_dump` and `pg_restore` installed. If you have a local install of these tools you should be able to skip the docker part. Be aware that it is only tested with the specific version of the tools that come with the postgres version used in the `Dockerfile`. (`FROM postgres:11.10`)

```bash
mv .env.sample .env
# edit the variables
docker compose up -d
docker ps 
# get your container id
docker exec -it [CONTAINERIDHERE] /bin/zsh
cd scripts
# needs the following environment variables set
# SOURCE_HOST
# SOURCE_USER
# SOURCE_DBNAME

export SOURCE_HOST=xxxxxxxxxxxxxx
export SOURCE_USER=xxxxxxxxxxxxxx
export SOURCE_DBNAME=xxxxxxxxxxxxxx
# will prompt for your source db password
./backup.sh
# needs the following environment variables set
# TARGET_HOST
# TARGET_USER
# TARGET_DBNAME
export TARGET_HOST=xxxxxxxxxxxxxx
export TARGET_USER=xxxxxxxxxxxxxx
export TARGET_DBNAME=xxxxxxxxxxxxxx
# will prompt for your target db pw
./restore.sh
# you might need to fiddle with postgis
```
