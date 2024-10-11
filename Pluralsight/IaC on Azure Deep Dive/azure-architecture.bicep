// PARAMETERS

@description('The target deployment environment type')
@allowed([
  'test'
  'prod'
])
param environmentName string

param awesomeFeatureEnabled bool

@description('Between 1 and 5 features only.')
@minValue(1)
@maxValue(5)
param awesomeFeatureCount int = 2 // supplied a default value for this parameter

@description('Between 5 and 25 characters long')
@minLength(5)
@maxLength(25)
param awesomeFeatureDisplayName string


// VARIABLES

var companyName = 'ASPFA'
var resourceName = '${companyName}-CompanyPortal'



// RESOURCES

resource serverFarm 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${resourceName}-${environmentName}'
  location: 'westeurope'
  sku:{
    name: 'S1'
  }
}

resource website 'Microsoft.Web/sites@2023-12-01' = {
  name: '${resourceName}-hb-${environmentName}'
  location: 'westeurope'
  // dependsOn: [ serverFarm ]
  properties: {
    serverFarmId:serverFarm.id
  }
}

resource websiteSettings 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: website // could have also included the websiteSettings resource directly in the website one instead
  name: 'appsettings'
  properties: {
    enableAwesomeFeature: string(awesomeFeatureEnabled) // string cast required as it's the only type accepted by the properties
    awesomeFeatureCount: string(awesomeFeatureCount)
    awesomeFeatureDisplayName: awesomeFeatureDisplayName
  }
}

// can also add notes like this
/*
  Or like this
*/
