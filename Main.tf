
resource "aws_vpc" "VPC-3Tier" {
    cidr_block         = "10.0.0.0/16"
    enable_dns_support = True
    enable_dns_hostnames = True
    tags = {
      Name = "VPC-3Tier"   
    } 
    
 }
  
  # Create Security Group

  resource "aws_security_group" "Allow-SSH" {

    vpc_id = aws_vpc.VPC-3Tier.id

    egress = {
          from_port = 0
          to_port = 0
          protocol = -1
          cidr_block = "0.0.0.0/0"
    }
    

    ingress = {

        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_block = "0.0.0.0/0"

    }
  }



# Create Public Subet

resource "aws_subnet" "Public-subnet1" {
  
    count       = length(var.public_subnet_cidr)
    vpc_id      = aws_vpc.VPC-3Tier.id
    cidr_block  = element(var.public_subnet_cidr, count.index)
    availability_zone = element(var.Azs, count.index)
    

    tags = {

        Name = "Public Subnet ${count.index + 1}"
    }
}


# Create Private Subet

resource "aws_subnet" "Private-subnet1" {

    count       = length(var.private_subnet_cidr)
    vpc_id      = aws_vpc.VPC-3Tier.id
    cidr_block  = element(var.private_subnet_cidr, count.index)
    availability_zone = element(var.Azs, count.index)
  
    tags = {

      Name = "Private Subnet ${count.index + 1}"
    
    }

}


# Create Internet Gateway

resource "aws_internet_gateway" "IGW-3Tier" {

        vpc_id = aws_vpc.VPC-3Tier

        tags = {
          "Name" = "VPC-3Tier Internet Gateway"
        }
}

# Create Public Route Table

resource "aws_route_table" "Public-Rt" {
  
  vpc_id = aws_vpc.VPC-3Tier

  route {

        cidr_block = "0.0.0.0"
        gateway_id = aws_internet_gateway.IGW-3Tier
  }
        tags = {
          "Name" = "Public RT"
        }
}

# Associate Public RT with Public Subnets

resource "aws_route_table_association" "Public-Rt-Assoc" {

    count     = length(var.public_subnet_cidr)
    subnet_id = element(aws_subnet.Public-subnet1[*].id, count.index)
    route_table_id = aws_route_table.Public-Rt.id
    
  
}