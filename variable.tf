# vpc variables
variable "vpc_cidr" {
  default        = "10.0.0.0/16"
  description    = "vpc cidr block"
  type           = string
}

variable "public_subnet_az1_cidr" {
  default        = "10.0.0.0/24"
  description    = "public subnet az1 cidr block"
  type           = string
}

variable "public_subnet_az2_cidr" {
  default        = "10.0.1.0/24"
  description    = "public subnet az2 cidr block"
  type           = string
}

variable "private_app_subnet_az1_cidr" {
  default        = "10.0.2.0/24"
  description    = "private app subnet az1 cidr block"
  type           = string
}

variable "private_app_subnet_az2_cidr" {
  default        = "10.0.3.0/24"
  description    = "private app subnet az2 cidr block"
  type           = string
}

variable "private_data_subnet_az1_cidr" {
  default        = "10.0.4.0/24"
  description    = "private data subnet az1 cidr block"
  type           = string
}

variable "private_data_subnet_az2_cidr" {
  default        = "10.0.5.0/24"
  description    = "private data subnet az2 cidr block"
  type           = string
}

# security group variables (default value should be myIP)
variable "ssh_location" {
  default        = "0.0.0.0/0"
  description    = "the ip address that can ssh into the ec2"
  type           = string
}

# rds variables
variable "database_snapshot_identifier" {
  default        = "arn:aws:rds:us-east-1:871909687521:snapshot:fleetcart-final-snapshot"
  description    = "database snapshot arn form the previous fleetcart project"
  type           = string
}

variable "database_instance_class" {
  default        = "db.t2.micro"
  description    = "the database instance type"
  type           = string
}
# identifier is from rds Instance/Cluster Name (in my case is dev-rds-db)
variable "database_instance_identifier" {
  default        = "dev-rds-db"
  description    = "the database instance identifier"
  type           = string
}

variable "multi_az_deployment" {
  default        = false
  description    = "create a standy db instance"
  type           = bool
}

# application load balancer variables
variable "ssl_certificate_arn" {
  default        = "arn:aws:acm:us-east-1:871909687521:certificate/cedb88ba-0aac-425b-9d8a-f5c037c1de8a"
  description    = "ssl certificate arn"
  type           = string
}

# sns topcis variables
variable "operator_email" {
  default        = "kchaggak@gmail.com"
  description    = "a valid email address"
  type           = string
}

# auto scalling group varaibles
variable "launch_template_name" {
  default        = "dev-launch-template"
  description    = "name of the launch template"
  type           = string
}

variable "ec2_image_id" {
  default        = "ami-037043f38ab901d99"
  description    = "id of the ami. In my case the ami has all the software (LAMP) from the previous deployment "
  type           = string
}

variable "ec2_instance_type" {
  default        = "t2.micro"
  description    = "the ec2 instance type "
  type           = string
}

variable "ec2_key_pair_name" {
  default        = "mywebserverKEYPAIR"
  description    = "name of the ec2 key pair "
  type           = string
}