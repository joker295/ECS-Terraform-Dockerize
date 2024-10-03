resource "aws_vpc" "main_vpc" {

    cidr_block = "10.0.0.0/16"
}


data "aws_availability_zones" "available" {

    state = "available"
  
}

resource "aws_subnet""subnets"{

    count                   = length(var.subnet_cidr)  
    vpc_id                  = aws_vpc.main_vpc.id
    cidr_block              = var.subnet_cidr[count.index]
    availability_zone       = data.aws_availability_zones.available.names[count.index] 
    map_public_ip_on_launch = "true"

    tags = {
      "Name" = var.subnet_names[count.index] 
    }
}


# IGW 
resource"aws_internet_gateway""main-igw"{


vpc_id = aws_vpc.main_vpc.id

}

# Route table 
resource "aws_route_table""rt_1"  {

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  
  }

  
vpc_id = aws_vpc.main_vpc.id


}


# Route Table Association 
resource "aws_route_table_association" "rta_1" {

    count          =  length(var.subnet_cidr)   
    subnet_id      = aws_subnet.subnets[count.index].id
    route_table_id = aws_route_table.rt_1.id
  
}