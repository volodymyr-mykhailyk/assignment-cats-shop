resource "aws_autoscaling_group" "main" {
  name_prefix = "${var.name}-"

  min_size = 1
  max_size = 3

  launch_template {
    id      = var.app_configuration.id
    version = var.app_configuration.version
  }

  health_check_type         = "ELB"
  health_check_grace_period = "120"

  vpc_zone_identifier = var.vpc.subnet_ids
}
