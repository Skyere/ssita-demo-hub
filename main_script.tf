
# Security group for EC2
resource "aws_security_group" "ec2_allow_rule" {


  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow ssh,http,https"
  }
}


# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow ec2"
  }

}

# Create RDS instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = ["${aws_security_group.RDS_allow_rule.id}"]
  name                   = var.database_name
  username               = var.database_user
  password               = var.database_password
  skip_final_snapshot    = true
  tags = {
    Role = "db"
    Env  = "rds"
  }
}


# Create EC2
resource "aws_instance" "wordpressec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = ["${aws_security_group.ec2_allow_rule.name}"]
  key_name = var.key_name
  tags = {
    Role = "instance"
    Env  = "ec2"
    Name = "Wordpress.web"
  }
  depends_on = [aws_db_instance.wordpressdb]
}

# creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id

}

output "IP" {
  value = aws_eip.eip.public_ip
}
output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

resource "null_resource" "Create_host_ec2" {

  depends_on = [aws_instance.wordpressec2]

  provisioner "local-exec" {
      command = "echo ${aws_eip.eip.public_ip} >> hosts/hosts.ini"

  }
}
resource "null_resource" "Create_host_db" {

  depends_on = [aws_db_instance.wordpressdb]

  provisioner "local-exec" {
      command = "echo endpoint: ${aws_db_instance.wordpressdb.endpoint} >> roles/vars/main.yml"

  }

}
