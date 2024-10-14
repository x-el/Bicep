// PARAMETERS

param resourceName string
param environmentName string
param resourceLocation string



// VARIABLES

var metricDetails = [
  {
    metricName: 'Failed Requests'
    metricIdentifier: 'requests/failed'
  }
  {
    metricName: 'Failed Dependencies'
    metricIdentifier: 'dependencies/failed'
  }
]



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

resource failureAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = if (environmentName == 'prod') {
  name: 'Rule for Failed Requests'
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    scopes: [
      applicationInsights.id
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          threshold: 1
          name: 'Failed Requests'
          metricNamespace: 'microsoft.insights/components'
          metricName: 'requests/failed'
          operator: 'GreaterThan'
          timeAggregation: 'Count'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
  }
}
