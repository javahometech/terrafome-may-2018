# Add EC2 instances in public subnet and install Apache
resource "aws_instance" "web" {
  count           = "${var.webservers_count}"
  ami             = "${lookup(var.amis,var.region)}"
  instance_type   = "${var.web_instance_type}"
  subnet_id       = "${element(aws_subnet.webservers.*.id, count.index)}"
  key_name        = "hari"
  user_data       = "${file("install-apache.sh")}"
  security_groups = ["${aws_security_group.webservers-sg.id}"]

  tags {
    Name = "Webserver-${count.index + 1}"
  }
}
