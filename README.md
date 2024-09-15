# Limble CMMS Assessment

**URL:** [https://ecs.assessment-sandbox.com](https://ecs.assessment-sandbox.com)

## Quick Description

This is a WordPress site running on AWS ECS (Elastic Container Service) utilizing the official WordPress Docker image. The site is backed by an RDS MySQL database, with sensitive information securely managed through AWS Secrets Manager. To enhance performance and scalability, a CloudFront CDN is set up in front of the ECS cluster's Application Load Balancer (ALB), optimizing content delivery and reducing latency.

### Bastion

I created a lightweight bastion host primarily for accessing the MySQL database to update values and troubleshoot issues.

**Future Improvements:**

I would automate configuration using a user-data script to install necessary tools like SSM Session Manager and MySQL client. I’d also enhance monitoring by enabling detailed CloudWatch metrics and alarms for better observability. Key rotation would be implemented to ensure security best practices.

### Cloudfront

I set up a CloudFront distribution in front of the ECS cluster's ALB to enhance the performance of the WordPress application by leveraging caching and reducing latency. For content-heavy platforms like WordPress, fast delivery of assets is crucial for user experience.

**Future Improvements:**

I would focus on designing a well-optimized caching strategy to ensure assets are delivered as quickly as possible, including automating cache invalidation during deployments or general updates. My next priority would be implementing AWS WAF to enhance security by protecting against threats like SQL injection attempts and other common attacks.

### RDS

I deployed a basic, private RDS instance configured with automatic backups, encryption, and a management policy for the master user password. Additionally, it creates a database subnet group for the RDS instance and manages database credentials through AWS Secrets Manager.

**Future Improvements:**

In a real-world setup, there's a good amount of tweaks I'd make to the RDS cluster. I'd enable multi-AZ deployments for better availability, turn on Performance Insights to keep an eye on performance, and export logs to CloudWatch for easier monitoring. I’d also set up IAM authentication and add read replicas to handle different types of queries and improve performance.

For an extra performance boost and better connection management, I'd throw in an ElastiCache Memcached cluster and use RDS Proxy.

### VPC

I set up a dedicated VPC for this project designed to encompass two private and two public subnets. I also wanted to make sure I provided a large pool of IP addresses. The public subnets are configured with route tables that leverage an internet gateway for external access, while the private subnets are securely routed through a NAT gateway for outbound traffic.

**Future Improvements:**

Looking back, I'd set up a separate NAT gateway for each private subnet to avoid any single point of failure. To save on costs, I'd also consider using a NAT instance instead of a gateway. Plus, adding IPv6 CIDRs would help future-proof the network and allow for more scalability.
