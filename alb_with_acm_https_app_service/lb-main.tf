#############################################
## Application Load Balancer Module - Main ##
#############################################

# Create a Security Group for The Load Balancer
resource "aws_security_group" "vijay-alb-sg" {
  name        = "${lower(var.app_name)}-${var.app_environment}-vijay-alb-sg"
  description = "Allow web traffic to the load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-vijay-alb-sg"
    Environment = var.app_environment
  }
}


# Create a Load Balancer Target Group for HTTP
resource "aws_lb_target_group" "vijay-alb-target-group" {  
  name     = "${lower(var.app_name)}-${var.app_environment}-vijay-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  
  deregistration_delay = 60

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
    matcher             = "200,301,302"
  }
}


# Attach EC2 Instances to Application Load Balancer Target Group
resource "aws_alb_target_group_attachment" "vijay-alb-target-group-attachment" {
  target_group_arn = aws_lb_target_group.vijay-alb-target-group.arn
  target_id        = aws_instance.vijay-server.id
  port             = 80
}

# Create an Application Load Balancer
resource "aws_lb" "vijay-alb" {
  name               = "${lower(var.app_name)}-${var.app_environment}-vijay-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.vijay-alb-sg.id]
  subnets            = local.ec2_subnet_list

  enable_deletion_protection = false
  enable_http2               = false

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-vijay-alb"
    Environment = var.app_environment
  }
}

# Create the Application Load Balancer Listener HTTPS
resource "aws_lb_listener" "vijay-alb-listener" {  
  depends_on = [aws_acm_certificate.vijay-alb-certificate]
  load_balancer_arn = aws_lb.vijay-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.vijay-alb-certificate.arn
  
  default_action {    
    target_group_arn = aws_lb_target_group.vijay-alb-target-group.arn
    type             = "forward"  
  }
}

resource "aws_lb_listener_certificate" "test" {
  depends_on = [aws_acm_certificate_validation.vijay-certificate-validation]
  listener_arn    = aws_lb_listener.vijay-alb-listener.arn
  certificate_arn = aws_acm_certificate.vijay-alb-certificate.arn
}


resource "aws_lb_listener_rule" "test" {
  listener_arn = aws_lb_listener.vijay-alb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vijay-alb-target-group.arn
  }

  condition {
    host_header {
      values = ["${var.dns_hostname}.${var.public_dns_name}"]
    }
  }
}

##################################################################################

# Reference to the AWS Route53 Public Zone
data "aws_route53_zone" "public-zone" {
  name         = var.public_dns_name
  private_zone = false
}


# Create AWS Route53 A Record for the Load Balancer
resource "aws_route53_record" "linux-alb-a-record" {
  depends_on = [aws_lb.vijay-alb]

  zone_id = data.aws_route53_zone.public-zone.zone_id
  name    = "${var.dns_hostname}.${var.public_dns_name}"
  type    = "A"

  alias {
    name                   = aws_lb.vijay-alb.dns_name
    zone_id                = aws_lb.vijay-alb.zone_id
    evaluate_target_health = true
  }
}

# ####################################################################################

# Create Certificate
resource "aws_acm_certificate" "vijay-alb-certificate" {
  domain_name       = "${var.dns_hostname}.${var.public_dns_name}"
  validation_method = "DNS"
  
  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-vijay-alb-certificate"
    Environment = var.app_environment
  }
}

# Create AWS Route 53 Certificate Validation Record
resource "aws_route53_record" "vijay-alb-certificate-validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.vijay-alb-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public-zone.zone_id
}

# Create Certificate Validation
resource "aws_acm_certificate_validation" "vijay-certificate-validation" {
  certificate_arn         = aws_acm_certificate.vijay-alb-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.vijay-alb-certificate-validation-record : record.fqdn]
}
