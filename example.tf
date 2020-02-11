provider "aws" {
  profile = "default"
  region  = var.region
}

# New resource for the S3 bucket our application will use.
resource "aws_s3_bucket" "example" {
  bucket = "crabbytabby2020"
  acl    = "private"
}

resource "aws_instance" "example" {
    ami           = "ami-038e6b679579b4ec1"
    instance_type = "t2.micro"

    # Tells Terraform that this EC2 instance must be created only after the
    # S3 bucket has been created.
    depends_on = [aws_s3_bucket.example]

    provisioner "local-exec" {
        command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}