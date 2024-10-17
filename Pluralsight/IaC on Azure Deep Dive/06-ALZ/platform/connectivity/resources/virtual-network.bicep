// PARAMETERS
param resourceLocation string
param vnetName string
param firewallSubnetName string
param bastionSubnetName string



// RESOURCES

resource hubNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: resourceLocation
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.10.0.0/16' ]
    }
    subnets: [
      {
        name: firewallSubnetName
        properties: {
          addressPrefix: '10.10.10.0/24'
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: '10.10.11.0/24'
        }
      }
    ]
  }
}
