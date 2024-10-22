// PARAMETERS

param resourceLocation string
param resourceName string
param environmentName string
param aspTier string
param websiteConfigurationSettings websiteConfigurationSettingsType



// CUSTOM DATA TYPES

@export()
type websiteConfigurationSettingsType = {
  
  awesomeFeatureEnabled: bool

  @description('Between 1 and 5 features only.')
  @minValue(1)
  @maxValue(5)
  awesomeFeatureCount: int
  
  @description('Between 5 and 25 characters long')
  @minLength(5)
  @maxLength(25)
  awesomeFeatureDisplayName: string
  
}



// RESOURCES


resource websiteManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'websiteManagedIdentity'
  location: resourceLocation
  tags: resourceGroup().tags
}

resource serverFarm 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${resourceName}-${environmentName}-asp'
  location: resourceLocation
  tags: resourceGroup().tags
  sku:{
    name: aspTier // F1 or S1
  }
}

resource website 'Microsoft.Web/sites@2023-12-01' = {
  name: 'resourceName-hb-${environmentName}-WebApp'
  location: resourceLocation
  tags: resourceGroup().tags
  // dependsOn: [ serverFarm ]
  properties: {
    serverFarmId:serverFarm.id
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${websiteManagedIdentity.id}': { }
    }
  }
}

resource websiteSettings 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: website // could have also included the websiteSettings resource directly in the website one instead
  name: 'appsettings'
  properties: {
    enableAwesomeFeature: string(websiteConfigurationSettings.awesomeFeatureEnabled) // string cast required as it's the only type accepted by the properties
    awesomeFeatureCount: string(websiteConfigurationSettings.awesomeFeatureCount)
    awesomeFeatureDisplayName: websiteConfigurationSettings.awesomeFeatureDisplayName
  }
}



// OUTPUTS

output websiteManagedIdentityName string = websiteManagedIdentity.name
output websiteManagedIdentityClientId string = websiteManagedIdentity.properties.clientId  // websiteManagedIdentity.id is incorrect
output websiteManagedIdentityPrincipalId string = websiteManagedIdentity.properties.principalId
