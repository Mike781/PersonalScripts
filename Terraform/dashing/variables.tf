#AWS Access and Secret Key variable
variable "access_key" {}
variable "secret_key" {}
variable "region" { default = "us-east-1" }

#AMI, Instance type, Name, AWS security group variable
variable "ami" {}
variable "inst_type" {}
variable "security_groups" {}
variable "name" {}

#SSH keyname and path variable
variable "keyname" {}
variable "sshkey" {}

#Dashboard variable
variable "dashboard" {}
