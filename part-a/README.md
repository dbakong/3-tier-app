## Take-Home Exercise: Multi-Instance Web Application with Database

### Part A: Single server with a small database

#### Application:
- Containerized using Docker
- Serves on port 8080
- Environment variables for database connectivity (DB_HOST, DB_PORT, DB_USER, DB_PASSWORD)

#### Infrastructure:
- Single EC2 instance (t2.micro) using Amazon Linux 2 AMI (ami-01b64707e9d9b7350)

#### Networking:
- Security groups allow HTTP (port 8080) and SSH (port 22) access from your local IP

#### DNS/Connectivity:
- Access to the application via the public or the public dns of the of the EC2 instance
- No custom DNS setup; direct IP access assumed

#### Architecture
``` bash
+-----------------------------------------------------+
|                       AWS VPC                       |
|                 (CIDR Block: 10.0.0.0/16)           |
|                                                     |
|   +--------------------------+  +-----------------+ |
|   |      Public Subnet 1      |  | Public Subnet 2 | |
|   |                           |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |   |    Web Server     |   |  |                 | |
|   |   |   (web_sg)        |   |  |                 | |
|   |   +-------------------+   |  |                 | |
|   +--------------------------+  +-----------------+ |
|                                                     |
|   +--------------------------+  +-----------------+ |
|   |     Private Subnet 1      |  |Private Subnet 2 | |
|   |                           |  |                 | |
|   |   +-------------------+   |  |                 | |
|   |   |     MySQL DB      |   |  |                 | |
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

#### Features

High Availability
- Uses one public and 2 private subnets in a single AZ
- No fault tolerance for service instances; an AZ failure results in downtime

Scalability
- server instances
    - One instance of the server instance is deployed
    - Limited scalability and fault tolerance
    - Single point of failure
- DB instances
    - One DB instance deployed
    - Scalable storage up to 1TB
    - multi-AZ deployment with one standby instance


Performance
- Sufficient for small workloads, but limited in performance

Complexity
- simpler setup
- web tier not scalable or fault-tolerant