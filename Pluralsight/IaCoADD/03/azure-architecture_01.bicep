// CUSTOM DATA TYPES

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



// PARAMETERS

@description('The target deployment environment type')
@allowed([
  'test'
  'prod'
])
param environmentName string

@description('Custom Website configuration settings data type')
param websiteConfigurationSettings websiteConfigurationSettingsType



// VARIABLES

var companyName = 'ASPFA'
var resourceName = '${companyName}-CompanyPortal'
var resourceLocation = resourceGroup().location
var aspTier = environmentName == 'prod' ? 'S1' : 'F1'



// MODULES

module applicationInsightsModule 'modules/applicationInsights.bicep' = {
  name: 'applicationInsights' // each module Deployment needs a name, because the module will translate into an individual Deployment in Azure
  params: {
      environmentName: environmentName
      resourceLocation: resourceLocation
      resourceName: resourceName
    }
}

module sqlDatabaseModule 'modules/sqlDatabase.bicep' = {
name: 'sqlDatabaseDeployment'
params: {
  environmentName: environmentName
  resourceLocation: resourceLocation
  companyName: companyName
  adminManagedIdentityName: websiteManagedIdentity.name 
  adminManagedIdentityClientId: websiteManagedIdentity.id
  }
}



// RESOURCES

resource websiteManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'websiteManagedIdentity'
  location: resourceLocation
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



// can also add notes like this
/*
  Or like this
*/
