## Take-Home Exercise: Multi-Instance Web Application with Database

### Part B: Scalable architecture with five servers, a medium-sized database, and a load balancer

#### Application:
- Containerized using Docker.
- Serves on port 8080.
- Environment variables for database connectivity (DB_HOST, DB_PORT, DB_USER, DB_PASSWORD).

#### Infrastructure:
- Auto Scaling Group (ASG) with five EC2 instances.
- Application Load Balancer (ALB) for traffic distribution.
- Amazon Linux 2 AMI (ami-01b64707e9d9b7350).

#### Networking:
- Security groups allow HTTP/HTTPS (ports 80/443) and SSH (port 22) access from your local IP.
- NAT gateways for internet access from private subnets.

#### DNS/Connectivity:
- Access to the application via the ALB DNS name.
- No custom DNS setup; ALB DNS name assumed for accessing the application.


#### Architecture

``` bash
+-----------------------------------------------------+
|                       AWS VPC                       |
|                  (CIDR Block: 10.0.0.0/16)          |
|                                                     |
|   +--------------------------+  +-----------------+ |
|   |      Public Subnet 1      |  | Public Subnet 2 | |
|   |                           |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |   |  Application Load |   |  |                 | |
|   |   |    Balancer       |   |  |                 | |
|   |   |     (alb_sg)      |   |  |                 | |
|   |   +-------------------+   |  |                 | |
|   +--------------------------+  +-----------------+ |
|                                                     |
|   +--------------------------+  +-----------------+ |
|   |     Private Subnet 1      |  |Private Subnet 2 | |
|   |                           |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |   |  Auto Scaling     |   |  |                 | |
|   |   |    Group (web_sg) |   |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |                           |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |   |   MySQL DB        |   |  |                 | |
|   |   |    (db_sg)        |   |  |                 | |
|   |   +-------------------+   |  |                 | |
|   +--------------------------+  +-----------------+ |
|                                                     |
+-----------------------------------------------------+
          |
          |
    +------------------+
    |   Internet      |
    |    Gateway      |
    +------------------+
```

``` bash
+-------------------+
|   ALB Listener    |
|    (port 80)      |
+-------------------+
         |
         v
+-------------------+    +--------------------+
| ALB Target Group  |--->|  Health Check      |
|     (web_tg)      |<---| (HTTP, path: "/")  |
+-------------------+    +--------------------+
         |
         v
+-------------------+
|  Auto Scaling     |
|   Group (web_sg)  |
+-------------------+
```

#### Features
High Availability
- Configuration: 
    - Uses two public and two private subnets across two AZs
- Implications: 
    - Improved fault tolerance and availability. If one AZ goes down, the application can still function.

Scalability
- Configuration: 
    - Server instances are scalable to 5 instances.
    - Scalable db storage up to 5TB
- Implications: Improved scalability, fault tolerance, and load distribution. Can handle increased traffic and failures better.

Performance
- Configuration: Uses a db.t3.medium instance with 20GB storage.
- Implications: Better performance and more storage capacity, suitable for larger workloads.

Complexity
- Configuration: Includes an Application Load Balancer.
- Implications: Provides better load distribution, fault tolerance, and ability to handle more traffic. Allows for rolling updates and blue-green deployments.



