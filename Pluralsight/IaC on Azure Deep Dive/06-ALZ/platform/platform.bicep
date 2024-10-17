// PARAMETERS

param resourceLocation string = 'westeurope'



// RESOURCE GROUPS

targetScope = 'subscription'
resource managementResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'Test-PS-Bicep-management'
  location: resourceLocation
}

resource connectivityResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'Test-PS-Bicep-connectivity'
  location: resourceLocation
}
