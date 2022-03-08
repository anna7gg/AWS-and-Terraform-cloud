variable "region" {
  default = "us-east-1"
  type = string
}

variable "private_subnet" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  default     = "whiskey"
  description = "The key name of the Key Pair to use for the instance"
  type        = string
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "web_instances_count" {
  default = 2
}

variable "DB_instances_count" {
  default = 2
}

variable "disk_size" {
  description = "The size of the disk"
  default = "10"
}

variable "volumes_type" {
  description = "The disk type"
  default = "gp2"
}

variable "bucket_name" {
  description = "bucket name for logs"
  default = "ops-nginx-web-server-logs"

}
variable "acl" {
  description = "canned ACL"
  default = "private"

}