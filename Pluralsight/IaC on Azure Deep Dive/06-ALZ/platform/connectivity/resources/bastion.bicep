// PARAMETERS
param resourceLocation string
param virtualNetworkName string
param bastionSubnetName string



// RESOURCES

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = { // Public IP creation
  name: 'bastion-pip'
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
