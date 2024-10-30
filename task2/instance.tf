resource "aws_instance" "public_instances" {
  count = length(var.public_subnet_cidrs)

  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name

  subnet_id                   =  element(aws_subnet.public_subnet[*].id, count.index)
  vpc_security_group_ids      = [aws_security_group.public_instance.id]
  associate_public_ip_address = true

   tags = {
    Name = "Public Instance  ${count.index + 1}"
    Environment = "Development"
  }
}

resource "aws_instance" "private_instances" {
  count = length(var.private_subnet_cidrs)

  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name

  subnet_id                   =  element(aws_subnet.private_subnet[*].id, count.index)
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  associate_public_ip_address = true

   tags = {
    Name = "Private Instance  ${count.index + 1}"
    Environment = "Development"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  key_name = var.ssh_key_name
  tags = {
    Name = "Bastion Host"
  }
}