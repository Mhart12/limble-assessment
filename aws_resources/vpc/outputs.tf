output "vpc_id" {
  description = "The ID of the default VPC"
  value       = aws_vpc.default.id
}