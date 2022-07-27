# General Variables

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-west-2"
}

# EC2 Variables

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = ""    # provide amazon linux ami us-west-2 region
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

#key_pair name

variable "key_name" {
  description = "ec2 keypair name"
  type        = string
  default     = ""    #give keypair name in aws 
}

#profile

variable "profile" {
  description = "aws profile name"
  type        = string
  default     = ""                    #give profile name
}

#vpc-id

variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = ""  #give existing deafult  vpc id
}

#subnet-id-1

variable "subnet-id-1" {
  description = "subnet id-1"
  type        = string
  default     = ""  #give existing deafault subnet id-1
}

#subnet-id-2

variable "subnet-id-2" {
  description = "subnet id-2"
  type        = string
  default     = ""  #give existing deafault subnet id-2
}

#security-group-id

variable "sg-id" {
  description = "security group id"
  type        = list
  default     = [""]  #give existing sg which allows required ports(22 and 4000)
}

