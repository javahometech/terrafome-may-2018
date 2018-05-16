# Create a new load balancer
resource "aws_elb" "jobassist-elb" {
  name            = "jobassist-elb"
  subnets         = ["${aws_subnet.webservers.*.id}"]
  security_groups = ["${aws_security_group.elb-sg.id}"]

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
    target              = "HTTP:80/index.html"
    interval            = 10
  }

  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  tags {
    Name = "jobassist-elb"
  }
}
