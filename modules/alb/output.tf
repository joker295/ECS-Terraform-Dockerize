output "alb" {

 value =aws_lb.Front-Facing-ALB.id

}


output "alb_tg" {
    value = aws_lb_target_group.ALB-TG.arn
  
}