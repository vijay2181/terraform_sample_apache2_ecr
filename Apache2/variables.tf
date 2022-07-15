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
  default     = ""    #give ami id built from packer
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
  default     = ""    #give keypair name of aws 
}

#profile

variable "profile" {
  description = "aws profile name"
  type        = string
  default     = "test"                    #give profile name
}

#subnet-id

variable "subnet-id" {
  description = "subnet id"
  type        = string
  default     = ""  #give existing subnet id
}

#security-group-id

variable "sg-id" {
  description = "security group id"
  type        = list
  default     = [""]  #give existing sg
}

#ecr repo name

variable "ecr-repo" {
  description = "ecr repo name"
  type        = string
  default     = ""  #ecr repo name
}

#ecr repo tag
variable "ecr-repo-tag" {
  description = "ecr repo tag"
  type        = string
  default     = ""  #ecr repo tag
}
