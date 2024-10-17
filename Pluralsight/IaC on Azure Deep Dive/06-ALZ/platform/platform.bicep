// PARAMETERS

param resourceLocation string = 'westeurope'



// RESOURCE GROUPS

targetScope = 'subscription' // default is 'resourceGroup'
resource managementResourceGroup 'Microsoft.Resources/resourceGroups@2024-08-01' = {
  name: 'Test-PS-Bicep-management'
  location: resourceLocation
}

resource connectivityResourceGroup 'Microsoft.Resources/resourceGroups@2024-08-01' = {
  name: 'Test-PS-Bicep-connectivity'
  location: resourceLocation
}
