output "aws-public-ip" {
  value = [
    for instance in aws_instance.example : {
      public_ip = instance.public_ip
      name = instance.tags.Name
    }
  ]
  }
