# variable "subnet_zone" {

#     type = list(string)
    
  
# }



variable "vpc_cidr"{

   description = "VPC_CIDR values"
   type        =   string
  }

variable "subnet_cidr"{

   description = "Subnet_CIDR values"
   type        =   list(string)


    
}
variable "subnet_names"{

   description = "Subnet_CIDR values"
   type        =   list(string)

}