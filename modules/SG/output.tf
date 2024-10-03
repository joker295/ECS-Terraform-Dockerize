output "ECS_SG" {
 value =  aws_security_group.ECS_SG.id

}


output "ALB_SG" {
 value =  aws_security_group.ALB_SG.id

}