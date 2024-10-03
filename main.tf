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



# # ECS SERVICE 

# resource "aws_ecr_repository" "app_ecr_repo" {
#   name = "app-r epo"

# }

# resource "aws_ecs_cluster" "my_cluster" {
#   name = "app-cluster" # Name your cluster here
# }

# resource "aws_ecs_task_definition" "app_task" {
#   family                   = "app-first-task"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   memory                   = 512
#   cpu                      = 256
#   execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

#   container_definitions = jsonencode([
#     {
#       name         = "app-first-task"
#       image        = "${aws_ecr_repository.app_ecr_repo.repository_url}:latest"
#       essential    = true
#       portMappings = [
#         {
#           containerPort = 5000
#           hostPort      = 5000
#         }
#       ]
#       memory = 512
#       cpu    = 256
#     }
#   ])
# }

# resource "aws_ecs_service" "app_service" {
#   name            = "app-first-service"     # Name the service
#   cluster         = "${aws_ecs_cluster.my_cluster.id}"   # Reference the created Cluster
#   task_definition = "${aws_ecs_task_definition.app_task.arn}" # Reference the task that the service will spin up
#   launch_type     = "FARGATE"
#   desired_count   = 3 # Set up the number of containers to 3

#   load_balancer {
#     target_group_arn = "${aws_lb_target_group.target_group.arn}" # Reference the target group
#     container_name   = "${aws_ecs_task_definition.app_task.family}"
#     container_port   = 5000 # Specify the container port
#   }

#   network_configuration {
#     subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
#     assign_public_ip = true     # Provide the containers with public IPs
#     security_groups  = ["${aws_security_group.service_security_group.id}"] # Set up the security group
#   }
# }






# # ALB


# resource "aws_alb" "application_load_balancer" {
#   name               = "load-balancer-dev" #load balancer name
#   load_balancer_type = "application"
#   subnets = [ # Referencing the default subnets
#     "${aws_default_subnet.default_subnet_a.id}",
#     "${aws_default_subnet.default_subnet_b.id}"
#   ]
#   # security group
#   security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
# }


# resource "aws_lb_target_group" "target_group" {
#   name        = "target-group"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "${aws_default_vpc.default_vpc.id}" # default VPC
# }

# resource "aws_lb_listener" "listener" {
#   load_balancer_arn = "${aws_alb.application_load_balancer.arn}" #  load balancer
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.target_group.arn}" # target group
#   }
# }

