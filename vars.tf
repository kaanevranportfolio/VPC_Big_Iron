variable "region" {
  default = "us-west-1"
}

variable "zone" {
  default = "us-west-1a"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}


variable "amiID" {
  type = map(any)
  default = {
    ubuntu = "ami-07d2649d67dbe8900"
    centos = "ami-0e614a6ae5310b145"
  }

}