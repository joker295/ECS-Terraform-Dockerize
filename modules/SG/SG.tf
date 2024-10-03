resource "aws_security_group""ECS_SG" {

        vpc_id = var.vpc_id

    ingress  {
        
description     = "Allow HTTPS traffic on container appliication"
        from_port       = 0
        to_port         = 0
        protocol        = -1
        security_groups = ["${aws_security_group.ALB_SG.id}"] 



}
}

# ####ALB-SG
resource "aws_security_group""ALB_SG" {

    vpc_id = var.vpc_id

    ingress {
        
        description   ="Allow HTTPS traffic on ALB"
        from_port     = 80
        to_port       = 80 
        protocol      = "tcp"
        cidr_blocks   =  ["0.0.0.0/0"]    

 }

    ingress{
        
        description ="Allow HTTPS traffic on ALB"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]    

 }


}

