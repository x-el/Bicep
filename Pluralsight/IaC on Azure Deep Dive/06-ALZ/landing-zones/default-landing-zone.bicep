targetScope = 'subscription'

// PARAMETERS
param resourceLocation string
param productName string
param spokeNumber string
param connectivityRgName string
param hubNetworkName string



// VARIABLES
var spokeRgName = 'Test-PS-Bicep-${spokeNumber}-${productName}'


// RESOURCES

resource spokeResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: spokeRgName
  location: resourceLocation
}



// MODULES

module spokeResourcesDeployment 'default-landing-zone/landing-zone.bicep' = {
  scope: spokeResourceGroup
  name: 'spokeResourcesTemplate'
  params: {
    resourceLocation: resourceLocation
    productName: productName
    spokeNumber: spokeNumber
    connectivityRgName: connectivityRgName
    hubNetworkName: hubNetworkName
  }
}
