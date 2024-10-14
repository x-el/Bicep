// PARAMETERS

param resourceName string
param environmentName string
param resourceLocation string



// RESOURCES

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
