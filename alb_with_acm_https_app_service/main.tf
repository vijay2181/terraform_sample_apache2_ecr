###################################
## Virtual Machine Module - Main ##
###################################

locals {
  ec2_subnet_list = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]
}

# Create EC2 Instances
resource "aws_instance" "vijay-server" {

  ami                         = data.aws_ami.amazon-linux-2022.id
  instance_type               = var.vijay_instance_type
  subnet_id                   = "${aws_subnet.public-subnet-1.id}"
  vpc_security_group_ids      = [aws_security_group.aws-vijay-sg.id]
  associate_public_ip_address = var.vijay_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = file("aws-user-data.sh")
  
  # root disk
  root_block_device {
    volume_size           = var.vijay_root_volume_size
    volume_type           = var.vijay_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.vijay_data_volume_size
    volume_type           = var.vijay_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-vijay-server"
    Environment = var.app_environment
  }
}

# Define the security group for the Linux server
resource "aws_security_group" "aws-vijay-sg" {
  name        = "${lower(var.app_name)}-${var.app_environment}-vijay-sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-vijay-sg"
    Environment = var.app_environment
  }
}
