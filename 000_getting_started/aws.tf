resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

resource "aws_instance" "my_server" {
  ami = "ami-03a6eaae9938c858c"
  instance_type = var.instance_type
  disable_api_termination = true
  ebs_optimized = true
  iam_instance_profile = var.iam_instance_profile
  monitoring = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "disabled"
  }
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name = "MyServer-${local.project_name}"
  }
}
  ami = "ami-03a6eaae9938c858c"
  instance_type = var.instance_type
  disable_api_termination = true
  ebs_optimized = true
  iam_instance_profile = var.iam_instance_profile
  monitoring = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
    http_put_response_hop_limit = 1
    http_endpoint = "disabled"
  }
  tags = {
    Name = "MyServer-${local.project_name}"
  }
}

/*
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.eu
  }

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
*/