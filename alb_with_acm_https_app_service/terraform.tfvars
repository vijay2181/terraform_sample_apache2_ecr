# Application Definition 
app_name        = "Vijay-app" # Do NOT enter any spaces
app_environment = "dev"       # Dev, Test, Staging, Prod, etc

# Network
vpc_cidr             = "10.11.0.0/16"
public_subnet_cidr_1 = "10.11.1.0/24"
public_subnet_cidr_2 = "10.11.2.0/24"
public_subnet_cidr_3 = "10.11.3.0/24"

# AWS Settings
aws_access_key = ""
aws_secret_key = ""
aws_region     = "us-west-2"

# DNS
public_dns_name = "example.com"
dns_hostname    = "lbtest"

#lbtest.example.com

# Linux Virtual Machine
ec2_count                         = 1
vijay_instance_type               = "t2.micro"
vijay_associate_public_ip_address = true
vijay_root_volume_size            = 8
vijay_root_volume_type            = "gp2"
vijay_data_volume_size            = 8
vijay_data_volume_type            = "gp2"
