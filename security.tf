# 1. The Web Bouncer (Public Subnet)
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow inbound HTTP/HTTPS from the world"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP (Port 80)
  ingress {
    description = "HTTP from public internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (Port 443)
  ingress {
    description = "HTTPS from public internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# 2. The Database Bouncer (Private Subnet - Chained!)
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow PostgreSQL access ONLY from Web Security Group"
  vpc_id      = aws_vpc.main.id

  # Allow PostgreSQL (Port 5432) ONLY from Web SG!
  ingress {
    description     = "PostgreSQL from Web Servers only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # <-- THE VIP BADGE CHAIN!
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}
