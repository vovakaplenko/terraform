### Remote terraform.tfstate configuration

terraform {
  backend "s3" {
    bucket  = "terraform-tfstate"
    region  = "eu-west-2"
    key     = "network/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

### Transit-VPC ###
module "transit" {
  source = "./modules/vpc"

  internet-gateway = true
  vpc_cidr_block   = "10.1.0.0/16"

  vpc-subnets = {
    transit-private1 = "10.1.1.0/24"
    transit-private2 = "10.1.2.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "transit"

  #  vpc-security-group = "vpc1-security-group"
}

### Common-VPC ###
module "common" {
  source = "./modules/vpc"

  internet-gateway = false
  vpc_cidr_block   = "10.10.0.0/16"

  vpc-subnets = {
    common-util       = "10.10.1.0/24"
    common-monitoring = "10.10.2.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "common"
}

### M2M VPC ###
module "m2m" {
  source = "./modules/vpc"

  internet-gateway = false
  vpc_cidr_block   = "10.20.0.0/16"

  vpc-subnets = {
    m2m-vpn = "10.20.1.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "m2m"
}

### PROD EC2 VPC ###
module "prod-ec2" {
  source = "./modules/vpc"

  internet-gateway = false
  vpc_cidr_block   = "10.40.0.0/16"

  vpc-subnets = {
    prod-ec2-prod   = "10.40.1.0/24"
    prod-ec2-ch     = "10.40.2.0/24"
    prod-ec2-fr     = "10.40.3.0/24"
    prod-ec2-secure = "10.40.200.0/24"
    prod-ec2-common = "10.40.220.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "prod-ec2"
}

### PROD RDS VPC ###
module "prod-rds" {
  source = "./modules/vpc"

  internet-gateway = false
  vpc_cidr_block   = "10.50.0.0/16"

  vpc-subnets = {
    prod-rds-prod   = "10.50.1.0/24"
    prod-rds-ch     = "10.50.2.0/24"
    prod-rds-core   = "10.50.3.0/24"
    prod-rds-secure = "10.50.200.0/24"
    prod-rds-common = "10.50.220.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "prod-rds"
}

### TEST VPC ###
module "test" {
  source = "./modules/vpc"

  internet-gateway = false
  vpc_cidr_block   = "10.60.0.0/16"

  vpc-subnets = {
    test-dev   = "10.60.1.0/24"
    test-test  = "10.60.2.0/24"
    test-int   = "10.60.3.0/24"
    test-stage = "10.60.200.0/24"
  }

  availability-zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc-name           = "test"
}
