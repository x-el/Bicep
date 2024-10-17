targetScope = 'subscription'

// PARAMETERS
param resourceLocation string
param productName string
param spokeNumber string



// VARIABLES
var spokeRgName = 'Test-PS-Bicep-${spokeNumber}-${productName}'


// RESOURCES

resource spokeResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: spokeRgName
  location: resourceLocation
}
