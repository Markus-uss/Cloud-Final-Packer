locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "social-something-app" {
  ami_name      = "social-something-app-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"

  # vpc_id                      = "vpc-089c54fb72f3421bf"
  # subnet_id                   = "subnet-03d2cd7b9da2d661e"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.social-something-app"]

  provisioner "file" {
    source = "./socialSomething.service"
    destination = "/tmp/socialSomething.service"
  }

  provisioner "file" {
    source = "../social_something_full.zip"
    destination = "/home/ec2-user/social_something_full.zip"
  }
  

  provisioner "shell" {
    script = "./app.sh"
  }
}
