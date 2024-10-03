# IAM ROLE 

module "iam" {

  source = "./modules/iam_roles"

}


module "vpc" {
  source      = "./modules/VPC"
  vpc_cidr    =  var.vpc_cidr
  subnet_cidr =  var.subnet_cidr
  subnet_names = var.subnet_names
  
}

module "SG" {

  source     = "./modules/SG"
  vpc_id     = module.vpc.vpc_id
  
}

module "ALB" {

  source         = "./modules/alb"
  vpc_id         =  module.vpc.vpc_id
  subnet_ids     =  module.vpc.subnet_ids
  ALB_SG         =  module.SG.ALB_SG 

  
}

# module "ECR" {

#   source = "./modules/ECR"
  
# }

module "ECS" {
  source               = "./modules/ecs"
  ecsTaskExecutionRole =  module.iam.ecsTaskExecutionRole 
  alb_tg               =  module.ALB.alb_tg
  subnet_ids           =  module.vpc.subnet_ids
  ECS_SG               =  module.SG.ECS_SG 
  # app_ecr_repo       =  module.ECR.app_ecr_repo 
  vpc_id               =  module.vpc.vpc_id 
  # ecs_log_group_name   = module.cloudwatch_log_group.ecs_log_group_name

}



