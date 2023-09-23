provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "jegan_ec2" {
  ami = "ami-024c22d5868672534"
  instance_type = "t2.micro"
  tags = {
    Name = "jegan-ec2"
  }
}