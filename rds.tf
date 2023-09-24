resource "aws_security_group" "rds_traffic" {
  name        = var.sg_name
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = [5432]
    iterator = port
    content {
      description = "ssh from anywhere"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_db_instance" "rds" {
  allocated_storage = 10
  db_name           = "postgresTerra"
  engine            = "postgres"
  # engine_version       = "5.7"
  instance_class = "db.t3.micro"
  vpc_security_group_ids = ["${aws_security_group.rds_traffic.id}"]
  username       = "flame"
  password       = "****"
  # parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint

}