resource "aws_elb" "nginx_lb" {
  name            = "nginx-classic-lb"
  subnets         = [data.terraform_remote_state.network.outputs.public_subnet_id]
  security_groups = [data.terraform_remote_state.network.outputs.lb_sg_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = aws_instance.nginx[*].id
}
