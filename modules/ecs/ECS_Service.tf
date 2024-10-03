# ECR Repo 

resource "aws_ecr_repository" "app_ecr_repo" {

  name = "app-ecr-repo"
  
}

#  ECS Cluster

resource "aws_ecs_cluster""TestCluster" {
  
  name = "TestCluster"
}

  # data "aws_ecr_repository""app_ecr_repo" {
  #    name = "app-repo"
  #  }


data "aws_ecr_image""app_ecr_repo" {
  
  repository_name = "app-repo"
  image_tag       = "latest"
 
  
}



data "aws_availability_zones" "available" {

    state = "available"
  
}

# ECS Task Definition 

resource "aws_ecs_task_definition""TestApp" {
  
  family                   = "TestApp"
  requires_compatibilities = ["FARGATE"]
  network_mode             =  "awsvpc"
  memory                   =  512 
  cpu                      =  256 
  execution_role_arn       = var.ecsTaskExecutionRole

    container_definitions = jsonencode([{

        name      = "app-first-task"
        image     = data.aws_ecr_image.app_ecr_repo.image_uri

         essential = true
        portMappings=[{
        
            containerPort = 5000
            hostPort      = 5000

                    }]
}])
}



# ECS Service Description 

resource "aws_ecs_service""Test-service" {
  
  name             = "Test-Service"
  cluster          = aws_ecs_cluster.TestCluster.id
  task_definition  = aws_ecs_task_definition.TestApp.arn  
  launch_type      = "FARGATE"
  desired_count    = 3


load_balancer {
    target_group_arn = var.alb_tg
    container_name   = "app-first-task"
    container_port   = 5000

  
}

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [var.ECS_SG]
  }

  }

