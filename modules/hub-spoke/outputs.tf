output "resource_group_name" {
  description = "Name of the resource group that holds the network."
  value       = azurerm_resource_group.this.name
}

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_ids" {
  description = "Resource IDs of the spoke virtual networks, keyed by spoke name."
  value       = { for k, v in azurerm_virtual_network.spoke : k => v.id }
}
