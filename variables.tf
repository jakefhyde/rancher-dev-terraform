# AWS

# Required
variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

# Required
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_session_token" {
  type        = string
  description = "AWS session token used to create AWS infrastructure"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "aws_zone" {
  type        = string
  description = "AWS zone used for all resources"
  default     = "us-east-1b"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "jhyde-rke1-aws-test"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ami_id" {
  type    = string
  default = "ami-04cc2b0ad9e30a9c8"
}

# Docker

variable "docker_version" {
  type    = string
  default = "20.10"
}

# Config

variable "instances" {
  type    = list(object({ name = string, roles = list(string), total = number }))
  default = [
    {
      name  = "etcd"
      roles = ["etcd"]
      total = 3
    },
    {
      name  = "controlplane"
      roles = ["controlplane"]
      total = 2
    },
    {
      name  = "worker"
      roles = ["worker"]
      total = 3
    }
  ]
}
