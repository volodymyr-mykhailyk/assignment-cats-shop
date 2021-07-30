resource "aws_security_group" "main" {
  vpc_id      = var.vpc.vpc_id
  name_prefix = "${var.name}-alb-"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "balancer" {
  name = "${var.name}-alb"
  load_balancer_type = "application"

  subnets = var.vpc.subnet_ids
  security_groups = concat([aws_security_group.main.id], var.assigned_security_groups)
}

resource "aws_lb_target_group" "http" {
  name = "${var.name}-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id

  health_check {
    interval = 5
    timeout = 3
    path = "/kittens/info"
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group_attachment" "instances" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.http.arn
  target_id        = element(var.instance_ids, count.index)
}

resource "aws_autoscaling_attachment" "autoscalers" {
  count = length(var.autoscaling_group_ids)

  alb_target_group_arn = aws_lb_target_group.http.arn
  autoscaling_group_name = element(var.autoscaling_group_ids, count.index)
}