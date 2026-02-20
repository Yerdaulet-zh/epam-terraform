resource "aws_instance" "nginx" {
  count                  = 2
  ami                    = local.ami
  instance_type          = "t2.micro"
  
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl start nginx
              
              echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Nginx-Server-${count.index + 1}"
  }
}
