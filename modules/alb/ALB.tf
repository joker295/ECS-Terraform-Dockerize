  # ##ALB 

  resource "aws_lb""Front-Facing-ALB" {

  name               = "Front-Facing-ALB"
  internal           =  false
  load_balancer_type = "application"
      
  subnets         = var.subnet_ids
  security_groups = [var.ALB_SG]


    
  }


  # ##ALB Target Group 
  resource "aws_lb_target_group" "ALB-TG" {

      name        ="ALB-TG"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip" 
      vpc_id      = var.vpc_id 

        health_check {
    path = "/"
    port = 5000
  }
  }
  # ##ALB Listner Rules

  resource "aws_lb_listener" "ALB-Listner"{

  load_balancer_arn =  "${aws_lb.Front-Facing-ALB.arn}"
  port              =  80
  protocol          = "HTTP"


  default_action {
    
    type             =  "forward"
    target_group_arn =  "${aws_lb_target_group.ALB-TG.arn}"

  }
    
  }



