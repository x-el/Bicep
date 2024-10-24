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
var resourceLocation = resourceGroup().location
var aspTier = environmentName == 'prod' ? 'S1' : 'F1'
// var aFeatureEven = awesomeFeatureCount % 2 == 0
// var calculatedAwFeEnabled = awesomeFeatureEnabled && aFeatureEven
// var inlineArray = [1, 2, 3]
// var combinedArray = concat(array1, array2)
// var sourceArray = [0, 1, 2, 3, 5, 6, 7]
// var threeAndFour = take(skip(sourceArray, 3), 2)
/*
  var sourceObject = {
    author: 'Henry'
    topic: 'Bicep'
  }
  var willBeTrue = contains (sourceObject, 'name')
  var willBeFalse = contains (sourceObject, 'modules')
  var jsonString = json(sourceObject)
*/

// RESOURCES

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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: 'aspfa-test-learn-ps-we-law'
  scope: resourceGroup(subscription().subscriptionId,'Test-Learn-PS-WE')
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${resourceName}-${environmentName}-AppIn'
  location: resourceLocation
  kind: 'web'
  tags: resourceGroup().tags
  properties: {
      Application_Type: 'web'
      WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// can also add notes like this
/*
  Or like this
*/
