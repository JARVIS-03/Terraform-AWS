# Terraform-AWS
Production-Grade AWS Infrastructure using Terraform

                                # High-Level AWS Architecture Workflow:

                                                ┌───────────────────────┐
                                                │      Route 53         │
                                                │ (DNS + Subdomain)     │
                                                └─────────┬─────────────┘
                                                        │
                                                        ▼
                                        ┌────────────────────────────┐
                                        │ Network Load Balancer (NLB)│ ◄── PUBLIC SUBNET
                                        └─────────┬──────────────────┘
                                                        │
                                        ┌────────────────────────────┐
                                        │ NAT Gateway (NAT)          │ ◄── PUBLIC SUBNET
                                        └─────────┬──────────────────┘
                                                        ▼
                                        ┌────────────────────────────┐
                                        │ Application Load Balancer  │ ◄── PRIVATE SUBNET
                                        └─────────┬──────────────────┘
                                                        │
                                        ┌───────────────┼──────────────────────────┐
                                        ▼               ▼                          ▼
                                ┌────────────┐   ┌────────────┐           ┌────────────────────┐
                                │ECS Service │   │ECS Service │   ...     │ECS Payment Service │ ◄── PRIVATE SUBNET
                                │(e.g., Auth)│   │(e.g., Prod)│           │  (port 8083)       │
                                └────────────┘   └────────────┘           └────────────────────┘

                                                        │
                                                        ▼
                                                ┌──────────────┐
                                                │    RDS DB    │ ◄── PRIVATE SUBNET
                                                └──────────────┘

# Security & Networking Layers:

                        Component:	            Subnet Type:	              Access:

                        Route 53	                N/A	                 External DNS
                        NLB	                       Public	        Accessible from the internet (TCP)
                        ALB	                       Private	        Accessed by NLB or internal routing
                        ECS Services	           Private	            Behind ALB, secure
                        RDS	                       Private	            No public access
                        NAT Gateway	               Public	        Allows outbound traffic from private subnets
                        Internet Gateway	       Public	        Enables public subnet internet access


# Module Mapping aka Wiring:

                        | Module         | Resources Created                       | Subnet Scope |
                        | -------------- | --------------------------------------- | ------------ |
                        | `vpc`          | VPC, Subnets (Public & Private), Routes | Both         |
                        | `nat_gateway`  | Elastic IP, NAT Gateway                 | Public       |
                        | `nlb`          | Network Load Balancer                   | Public       |
                        | `alb`          | Application Load Balancer               | Private      |
                        | `ecs_clusters` | ECS Cluster, Task Definitions, Services | Private      |
                        | `rds`          | DB Instance, DB Subnet Group, SG        | Private      |
                        | `route53`      | Hosted Zone Record                      | N/A          |
