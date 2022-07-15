provider "aws" {
  region     = "us-west-2"
  profile    = "test"
}

resource "aws_instance" "VIJAY-TERRAFORM" {
  ami                    = var.ami                                 
  instance_type          = var.instance_type
  key_name               = var.key_name           
  subnet_id              = var.subnet-id
  vpc_security_group_ids = var.sg-id
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.vijay_profile.name}"
  

  tags = {
    "Name" = "VIJAY-TERRAFORM"
    "Demo" = "Test"
  }

  provisioner "remote-exec" {
    inline = [
      "aws --region ${var.region} ecr get-login --no-include-email |bash",
      "docker pull ${local.account_id}.dkr.ecr.us-west-2.amazonaws.com/${var.ecr-repo}:${var.ecr-repo-tag}",
      "docker run -itd --name vijay -p 80:80 ${local.account_id}.dkr.ecr.us-west-2.amazonaws.com/${var.ecr-repo}:${var.ecr-repo-tag}",
      "touch configure.sh",
      "echo helloworld remote provisioner >> configure.sh",
      "mkdir vijay.txt",
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("/vagrant/${var.key_name}.pem")
      timeout     = "4m"
   }
}

resource "aws_eip" "my-eip" {
  instance = aws_instance.VIJAY-TERRAFORM.id
  vpc      = true
  tags        = {
      "Name"    = "VIJAY-TERRAFORM"
    }
}
