// PARAMETERS
param resourceLocation string



// VARIABLES
var vnetName = 'aspfa-test-ps-bicep-hub'
var firewallSubnetName = 'AzureFirewallSubnet'
var bastionSubnetName = 'AzureBastionSubnet'

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

module bastionDeployment 'resources/bastion.bicep' = {
  name: 'bastionDeployment'
  params: {
    resourceLocation: resourceLocation
    virtualNetworkName: vnetName
    bastionSubnetName: bastionSubnetName
  }
  dependsOn: [ virtualNetworkDeployment ] // explicit dependency declaration
}



// RESOURCES

