# Limble CMMS Assessment

**URL:** [https://ecs.assessment-sandbox.com](https://ecs.assessment-sandbox.com)

## Quick Description

This is a WordPress site running on AWS ECS (Elastic Container Service) utilizing the official WordPress Docker image. The site is backed by an RDS MySQL database, with sensitive information securely managed through AWS Secrets Manager. To enhance performance and scalability, a CloudFront CDN is set up in front of the ECS cluster's Application Load Balancer (ALB), optimizing content delivery and reducing latency.
