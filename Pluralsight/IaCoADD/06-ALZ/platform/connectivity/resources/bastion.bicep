// PARAMETERS
param resourceLocation string
param virtualNetworkName string
param bastionSubnetName string



// RESOURCES

resource bastionPublicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = { // Public IP creation
  name: 'bastion-pip'
  location: resourceLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = { // calling the existing/previously created VNET
  name: virtualNetworkName
  resource bastionSubnet 'subnets@2024-01-01' existing = {
    name: bastionSubnetName
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2024-01-01' = { // creating the Bastion Host itself
  name: 'bastion-host'
  location: resourceLocation
  properties: {
    ipConfigurations: [{ // each BH can have multiple IP configurations, specified as an Array object
      name: 'ipConfiguration'
      properties: {
        subnet: {
          id: virtualNetwork::bastionSubnet.id
        }
        publicIPAddress: {
          id: bastionPublicIp.id
        }
      }
    }]
  }
}
