# giessdenkiez.de DB provisioning

These are some scripts and tools to setup a Postgres DB and provision the needed tables for the giessdenkiez.de project.


## Prerequisites

- Terraform (install using [asdf](https://asdf-vm.com/#/))

## Setup

Follow the terraform AWS setup instructions to get your credentials right

```bash
cd terraform
asdf install
terraform init
mv terraform.tfvars.example terraform.tfvars
```
Fill in all the variables in `terraform.tfvars`.
## Usage

```bash
cd terraform
terraform apply
```

Now connect to your RDS DB and install Postgis using the script `provisioning/enable-postgis-on-aws.sql`