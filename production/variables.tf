variable "dbname" {
  type    = string
  default = "trees"
}

variable "username" {
  type        = string
  description = "the user for the db"
}

variable "password" {
  type = string
}

variable "vpc_id" {
  type = string
}
