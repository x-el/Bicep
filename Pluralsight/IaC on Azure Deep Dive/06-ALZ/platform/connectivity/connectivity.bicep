// PARAMETERS
param resourceLocation string



// VARIABLES
var vnetName = 'aspfa-test-ps-bicep-hub'
var firewallSubnetName = 'AzureFirewallSubnet'
var  bastionSubnetName = 'AzureBastionSubnet'

// MODULES

module virtualNetworkDeployment 'resources/virtual-network.bicep' = {
  name: 'virtualNetworkDeployment'
  params: {
    resourceLocation: resourceLocation
    vnetName: vnetName
    firewallSubnetName: firewallSubnetName
    bastionSubnetName: bastionSubnetName
  }
}



// RESOURCES

