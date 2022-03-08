variable "private_subnet" {
  type    = list(string)
  description = "List of private subnet of the VPC"
}

variable "public_subnet" {
  type    = list(string)
  description = "List of public subnet of the VPC"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "Cider block pf the VPC"
}
