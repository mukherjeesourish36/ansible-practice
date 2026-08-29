output "aws-public-ip" {
  value = [
    for instance in aws_instance.example : instance.public_ip
  ]
}
