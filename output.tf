output "instances_public_ip" {
  description = "Public address of the load balancer"
  value = module.ec2_instances.instances_public_ip
}