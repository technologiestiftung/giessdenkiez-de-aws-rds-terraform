![](https://img.shields.io/badge/Built%20with%20%E2%9D%A4%EF%B8%8F-at%20Technologiestiftung%20Berlin-blue)

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
#
#
# ----------------------------------------
# this is in a docker container session
cd scripts
# needs the following environment variables set
# they are in .env and loaded with docker compose
# SOURCE_HOST
# SOURCE_USER
# SOURCE_DBNAME

# will prompt for your source db password
./backup.sh
# needs the following environment variables set
# they are in .env and loaded with docker compose
# TARGET_HOST
# TARGET_USER
# TARGET_DBNAME

# will prompt for your target db pw
./restore.sh
# you might need to fiddle with postgis
```

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://fabianmoronzirfas.me/"><img src="https://avatars.githubusercontent.com/u/315106?v=4?s=64" width="64px;" alt=""/><br /><sub><b>Fabian Morón Zirfas</b></sub></a><br /><a href="https://github.com/technologiestiftung/giessdenkiez-de-aws-rds-terraform/commits?author=ff6347" title="Code">💻</a> <a href="https://github.com/technologiestiftung/giessdenkiez-de-aws-rds-terraform/commits?author=ff6347" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/vogelino"><img src="https://avatars.githubusercontent.com/u/2759340?v=4?s=64" width="64px;" alt=""/><br /><sub><b>Lucas Vogel</b></sub></a><br /><a href="https://github.com/technologiestiftung/giessdenkiez-de-aws-rds-terraform/commits?author=vogelino" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Credits

<table>
  <tr>
    <td>
      <a src="https://citylab-berlin.org/en/start/">
        <br />
        <br />
        <img width="200" src="https://logos.citylab-berlin.org/logo-citylab-berlin.svg" />
      </a>
    </td>
    <td>
      A project by: <a src="https://www.technologiestiftung-berlin.de/en/">
        <br />
        <br />
        <img width="150" src="https://logos.citylab-berlin.org/logo-technologiestiftung-berlin-en.svg" />
      </a>
    </td>
    <td>
      Supported by:
      <br />
      <br />
      <img width="120" src="https://logos.citylab-berlin.org/logo-berlin.svg" />
    </td>
  </tr>
</table>
