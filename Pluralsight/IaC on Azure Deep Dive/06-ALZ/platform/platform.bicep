// PARAMETERS
param resourceLocation string
param loglogAnalayticsWorkspaceName string



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



// MODULES

module managementResourcesDeployment 'management/management.bicep' ={
  scope: managementResourceGroup
  name: 'managementResourcesDeployment'
  params: {
    resourceLocation: resourceLocation
    logAnalayticsWorkspaceName: loglogAnalayticsWorkspaceName
  }
}

module connectivityResourcesDeployment 'connectivity/connectivity.bicep' ={
  scope: connectivityResourceGroup
  name: 'connectivityResourcesDeployment'
  params: {
    resourceLocation: resourceLocation
  }
}
