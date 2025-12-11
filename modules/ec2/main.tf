data "aws_ami" "al2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

data "aws_secretsmanager_secret_version" "keypair" {
  secret_id = var.key_secret_name
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = data.aws_secretsmanager_secret_version.keypair.secret_string

  tags = {
    Name = "${var.env}-${var.name}"
  }
}