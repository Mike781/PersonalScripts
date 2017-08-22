#Fill out terraform.tfvars.example file and rename to terraform.tfvars before running

provider "aws" {
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.region}"
}

resource "aws_instance" "ubuntu" {
  ami           = "${var.ami}"
  instance_type = "${var.inst_type}"
  security_groups = ["${var.security_groups}"]
 tags {
	Name = "${var.name}"
	}
  key_name = "${var.keyname}"

#Set to true if you need EC2 Termination protection enabled
disable_api_termination = "true"

#Default ebs root size is 8GB, uncomment below lines if needed to specify size
#root_block_device {
#	volume_size = 12
#}

provisioner "remote-exec" {
	inline = [
	"sudo apt-get update -y",
	"sudo apt-get install ruby ruby-dev build-essential nodejs -y",
	"sudo gem install bundler",
	"sudo gem install dashing",
	"dashing new ${var.dashboard}"
]
connection {
	type = "ssh"
	user = "ubuntu"
	private_key = "${file(var.sshkey)}"
	}
   }
provisioner "local-exec" {
        command = "echo ${aws_instance.ubuntu.public_ip}"
        }

}
