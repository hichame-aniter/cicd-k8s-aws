# Global
variable "project" {
    description = "Project name"
    type = string
}
variable "environment" {
    type = string
}

# EC2
variable "controlplane_list" {
}
variable "node_list" {
}
variable "loadbalancer_ip" {
}
variable "ami" {
    description = "OS Image"
    type = string
}
variable "instance_type" {
    description = "Instance Size"
    type = string
}
variable "instances_state" {
    description = "EC2 instance state"
    type = string
    default = "stopped"
}

# VPC
variable "private_subnet_cidrs" {
    description = "VPC Private Subnet CIDRs"
    type = list(string)
}
variable "public_subnet_cidrs" {
    description = "VPC Public Subnet CIDRs"
    type = list(string)
}
variable "availability_zones" {
    description = "VPC Subnet availability_zones"
    type = list(string)
}
