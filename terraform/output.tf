output "instance_ids" {
  value = { for k, inst in module.ec2_instance : k => inst.id }
}

output "public_ips" {
  value = { for k, inst in module.ec2_instance : k => inst.public_ip }
}
