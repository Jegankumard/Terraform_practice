resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr 
}

resource "aws_internet_gateway" "igw" {
    depends_on = [ aws_vpc.myvpc ]
    vpc_id = aws_vpc.myvpc.id  
}

resource "aws_subnet" "sub1" {
    depends_on = [ aws_vpc.myvpc ]
    vpc_id = aws_vpc.myvpc.id

    cidr_block = var.cidr
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
    depends_on = [ aws_vpc.myvpc ]
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.cidr
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

resource "aws_route_table" "rt" {
    depends_on = [ aws_vpc.myvpc, aws_internet_gateway.igw ]
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = var.cidr
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta1" {
    depends_on = [ aws_subnet.sub1, aws_route_table.rt ]
    subnet_id      = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rta2" {
    depends_on = [ aws_subnet.sub2, aws_route_table.rt ]
    subnet_id      = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "awssg" {
  depends_on = [ aws_vpc.myvpc]
  name        = "awssg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.myvpc.cidr_block]
  }
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.myvpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "awssg"
  }
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "AwsTerraformBucketJK"
}

resource "aws_instance" "ec2_1" {
    depends_on = [ aws_security_group.awssg, aws_subnet.sub1 ]
    ami                     = "ami-0261755bbcb8c4a84"
    instance_type           = "t2.micro"
    vpc_security_group_ids = [aws_security_group.awssg.id]
    subnet_id              = aws_subnet.sub1.id
    user_data              = base64encode(file("user_data_1.sh"))
}
resource "aws_instance" "ec2_2" {
    depends_on = [ aws_security_group.awssg, aws_subnet.sub2 ]
    ami                     = "ami-0261755bbcb8c4a84"
    instance_type           = "t2.micro"
    vpc_security_group_ids = [aws_security_group.awssg.id]
    subnet_id              = aws_subnet.sub2.id
    user_data              = base64encode(file("user_data_2.sh"))
}
resource "aws_lb" "myalb" {
    depends_on = [ aws_security_group.awssg, aws_subnet.sub1, aws_subnet.sub2 ]
    name               = "myalb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.awssg.id]
    subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
    tags = {
        Name = "awssg"
    }
}

resource "aws_lb_target_group" "tg" {
  depends_on = [ aws_vpc.myvpc ]
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  depends_on = [ aws_instance.ec2_1, aws_lb_target_group.tg ]
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  depends_on = [ aws_instance.ec2_2, aws_lb_target_group.tg ]
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  depends_on = [ aws_lb_target_group.tg ]
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  depends_on = [ aws_lb.myalb ]
  value = aws_lb.myalb.dns_name
}
