provider "aws" {
    region =  "ap-south-1"
}

resource "aws_instance" "foo" {
  ami           = ami-0fd05997b4dff7aac #  "ap-south-1"
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
