// PARAMETERS
param resourceLocation string
param loglogAnalayticsWorkspaceName string
param managementRgName string
param connectivityRgName string


// RESOURCE GROUPS

targetScope = 'subscription' // default is 'resourceGroup'
resource managementResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: managementRgName
  location: resourceLocation
}

resource connectivityResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: connectivityRgName
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
    logAnalyticsWorkspaceName: loglogAnalayticsWorkspaceName
    managementRgName: managementRgName
  }
}
