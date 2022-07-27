terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
    remote = {
      source = "tenstad/remote"
      version = "0.1.0"
    }
  }
}

provider "aws" {
  region     = var.region
  profile    = var.profile
}

provider "remote" {
}


resource "aws_instance" "VIJAY-TERRAFORM" {
  ami                    = var.ami                                 
  instance_type          = var.instance_type
  key_name               = var.key_name           
  subnet_id              = var.subnet-id-1
  vpc_security_group_ids = var.sg-id
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.vijay_profile.name}"
  user_data = "${file("docker.sh")}"

  tags = {
    "Name" = "VIJAY-TERRAFORM"
    "Backend" = "VIJAY"
    "Tenant" = "TERRAFORM"
  }

  provisioner "file" {
    source      = "configure"
    destination = "/home/ec2-user/"
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("/vagrant/${var.key_name}.pem")   #provide pem file of aws 
      timeout     = "4m"
   }
}


resource "aws_lb_target_group" "vijay-target-group" {
  health_check {
    interval            = 30
    path                = "/index.html"
    protocol            = "HTTP"
    timeout             = 6
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  name        = "vijay-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "vijay-target-group-attachment" {
  target_group_arn = "${aws_lb_target_group.vijay-target-group.arn}"
  target_id        = aws_instance.VIJAY-TERRAFORM.id
  port             = 4000
}

resource "aws_lb" "vijay-alb" {
  name     = "vijay-alb"
  internal = false

  security_groups = [
    "${aws_security_group.vijay-alb-sg.id}",
  ]

  subnets = [
    var.subnet-id-1,
    var.subnet-id-2,
  ]

#we are giving two subnets beacuse lb should be launched in at altest two subnets 

  tags = {
    Name = "vijay-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "vijay-alb-listner" {
  load_balancer_arn = "${aws_lb.vijay-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.vijay-target-group.arn}"
  }
}

