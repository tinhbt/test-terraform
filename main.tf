module "vpc" {
  source = "./modules/vpc"
  
  #vpc_name= var.VPC_NAME
  ENV = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
  VPC_CIDR = var.VPC_CIDR
  PUBLIC_SUBNET_NUMBERS = var.PUBLIC_SUBNET_NUMBERS
  PRIVATE_SUBNET_NUMBERS = var.PRIVATE_SUBNET_NUMBERS
}