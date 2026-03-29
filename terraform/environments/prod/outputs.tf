output "server_ipv4_address" {
  value       = module.compute.public_ip_address
  description = "The public IPv4 address of the Minecraft server instance."
}
