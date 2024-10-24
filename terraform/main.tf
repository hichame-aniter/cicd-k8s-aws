resource "aws_instance" "controlplane01" {
	ami = var.ami
	instance_type = var.instance_type
}