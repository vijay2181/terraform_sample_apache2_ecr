########################################
## Virtual Machine Module - Variables ##
########################################

variable "ec2_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 1
}

variable "vijay_instance_type" {
  type        = string
  description = "EC2 instance type for Linux Server"
  default     = "t2.micro"
}

variable "vijay_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = false
}

variable "vijay_root_volume_size" {
  type        = number
  description = "Volume size of root volumen of Linux Server"
}

variable "vijay_data_volume_size" {
  type        = number
  description = "Volume size of data volumen of Linux Server"
}

variable "vijay_root_volume_type" {
  type        = string
  description = "Volume type of root volumen of Linux Server. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}

variable "vijay_data_volume_type" {
  type        = string
  description = "Volume type of data volumen of Linux Server. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}
