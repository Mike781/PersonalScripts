#Fill out terraform.tfvars.example file and rename to terraform.tfvars

provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}

resource "aws_instance" "ec2" {
  ami           = "${var.ami}"
  instance_type = "${var.inst_type}"
  security_groups = ["${var.security_groups}"]
 tags {
	Name = "${var.name}"
	}
  key_name = "${var.keyname}"

#Default ebs root size is 8GB, uncomment below lines if needed to specify size
#root_block_device {
#	volume_size = 40
#}

provisioner "remote-exec" {
	inline = [
	"sudo yum update -y",
#Add other inline commands here
	]
connection {
	type = "ssh"
	user = "ec2-user"
	private_key = "${file(var.sshkey)}"
	}
}
provisioner "local-exec" {
	command = "echo ${aws_instance.ec2.public_ip}"
	}
	
}
