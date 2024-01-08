## Terraform files to create VPC in AWS

- provider.tf
- main.tf
- variables.tf
- userdata on 1 instance
- userdata on 2 instance

### provider.tf
- terraform block
  > req provider source and version
- provider block
  > region
  
### main.tf
- aws vpc
  > cidr_block
- aws internet gateway
  > vpc_id
- aws subnet1
  > vpc_id, cidr_block, avail zone, map public ip
- aws subnet2
  > vpc_id, cidr_block, avail zone, map public ip
- aws route table
  > vpc_id, route - cidr_block, gateway_id
- aws route table association1
  > subnet_id, route_table_id
- aws route table association2
  > subnet_id, route_table_id
- aws security group
  > name, desc, vpc_id, ingress, egress, tags
  > ingress - desc, from_port, to_port, protocol, cidr_block
  > egress - desc, from_port, to_port, protocol, cidr_block, ipv6_cidr_blocks
- aws s3 bucket
  > bucket
- aws ec2 instance1
  > ami, instance_type, vpc_sec_grp_id, subnet_id, user_data
- aws ec2 instance2
  > ami, instance_type, vpc_sec_grp_id, subnet_id, user_data
- aws alb
  > name, internal, lb_type, sec_grp, subnets, tags
- aws lb target group
  > name, port, protocol, vpc_id, health_check
  > health_check - port, path
- aws lb target group attachment1
  > tar_grp_arn, port, protocol
- aws lb target group attachment2
  > tar_grp_arn, port, protocol
- aws lb listener
  > lb_arn, port, protocol, default_action
  > default_action - type, ter_grp_arn
- output aws lb dns to access application
