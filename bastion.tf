# Security group for the bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.vpc.id

  # SSH access from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP address
    description = "SSH access from admin IP"
  }

  # Outbound access to everywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "bastion-security-group"
  }
}

# EC2 instance for bastion host
resource "aws_instance" "bastion" {
  ami                    = "ami-08b5b3a93ed654d19"  # Amazon Linux 2 AMI (update this to the latest AMI in your region)
  instance_type          = "t2.micro"
  key_name               = var.ec2_key_pair_name  # SSH key pair name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_subnet_az1.id  # Place in a public subnet
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              # Install any additional tools you might need
              yum install -y mysql
              yum install -y postgresql
              yum install -y jq
              EOF

  tags = {
    Name = "bastion-host"
  }
}

# Elastic IP (optional but recommended for a stable public IP)
# resource "aws_eip" "bastion_eip" {
#   instance = aws_instance.bastion.id
#   domain   = "vpc"
  
#   tags = {
#     Name = "bastion-eip"
#   }
# }

# # Output the public IP of the bastion host
# output "bastion_public_ip" {
#   value       = aws_eip.bastion_eip.public_ip
#   description = "Public IP address of the bastion host"
# }

# Allow the private instances to accept SSH from the bastion
resource "aws_security_group_rule" "private_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.app_security_group.id  # Your application instances' security group
  description              = "Allow SSH from bastion host"
}