# create database subnet group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "database subnets"
  subnet_ids   = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]
  description  = "subnets for database instance"

  tags   = {
    Name = "database subnets"
  }
}

# create database instance without using snapshot
# terraform aws db instance
resource "aws_db_instance" "database_instance" {
  instance_class          = var.database_instance_class
  skip_final_snapshot     = true
  availability_zone       = "us-east-1b"
  identifier              = var.database_instance_identifier
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  multi_az                = var.multi_az_deployment
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  
  # Required parameters when not using a snapshot
  allocated_storage       = 20  # GB, adjust as needed
  engine                  = "mysql"  # or whatever engine you need: postgres, mariadb, etc.
  engine_version          = "8.0.35"    # adjust based on your engine
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"  # adjust based on your engine
}

# EC2 instance or Lambda function to handle the data migration
resource "aws_instance" "db_migration_instance" {
  ami                    = "ami-08b5b3a93ed654d19"  # Amazon Linux 2 AMI (adjust as needed)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_app_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.app_security_group.id]
  key_name               = var.ec2_key_pair_name
  
  # This script will run on the instance to migrate data
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mysql
              
              # Install your data migration tools here
              # For example, if you're exporting from a backup file:
              aws s3 cp s3://${var.backup_bucket}/V1__nest.sql /tmp/
              
              # Wait for RDS to be available
              sleep 60
              
              # Import data to new RDS instance
              mysql -h ${aws_db_instance.database_instance.address} -u ${var.db_username} -p${var.db_password} < /tmp/backup.sql
              
              # Shutdown the instance after migration completes
              shutdown -h now
              EOF

  tags = {
    Name = "DB-Migration-Instance"
  }
  
  # Only create this instance after the database is available
  depends_on = [aws_db_instance.database_instance]
}

# # Optional: null_resource with local-exec provisioner as an alternative approach
# resource "null_resource" "db_migration" {
#   # This will run on the machine executing terraform
#   provisioner "local-exec" {
#     command = <<-EOT
#       # Wait for RDS to be available
#       sleep 60
      
#       # Execute your migration script
#       ./migrate_data.sh \
#         --host=${aws_db_instance.database_instance.address} \
#         --user=${var.db_username} \
#         --password=${var.db_password} \
#         --database=${var.database_name}
#     EOT
#   }
  
#   depends_on = [aws_db_instance.database_instance]
  
#   # Only run this once when the DB changes
#   triggers = {
#     instance_id = aws_db_instance.database_instance.id
#   }
# }