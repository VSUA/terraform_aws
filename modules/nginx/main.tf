resource "aws_security_group" "http_sg" {
  name        = "http_sg"
  vpc_id      = var.aws_vpc_id

  ingress = {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }


  egress = {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
}


//.public.*.id
resource "aws_lb" "nginx" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_sg.id]
  subnets            = var.aws_pub_subnet.*.id
}

resource "aws_launch_template" "nginx" {
  name_prefix   = "nginx"
  image_id      = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install -y nginx
              sudo systemctl start nginx
              EOF
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = var.aws_priv_subnet.*.id
  target_group_arns = [aws_lb.nginx.arn]
  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }
}