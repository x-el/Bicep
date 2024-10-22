// PARAMETERS

param resourceName string
param environmentName string
param resourceLocation string
param metricsPublisherPrincipalId string



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

var metricsPublisherWellKnownId = '3913510d-42f4-4e42-8a64-420c390055eb' 



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

resource metricsPublisherRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: metricsPublisherWellKnownId // Azure well-known GUID (available in the Microsoft Documentation)
}

resource monitoringMetricsPublisherRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = { // Creating Extension Resource
  scope: applicationInsights // The containing Resource from within the template that the created ER will apply to
  name: guid(applicationInsights.name, metricsPublisherPrincipalId, metricsPublisherRoleDefinition.id) // always needs to be a GUID; using the guid function to generate one: resource it is applied to, the Principal that it's given to, which Role is it given 
  properties: {
    principalId: metricsPublisherPrincipalId
    roleDefinitionId: metricsPublisherRoleDefinition.id // resource ID of a Role Definition
  }
}

resource failureAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = [ for metricDetail in metricDetails: if (environmentName == 'prod') {
    name: 'Rule for ${metricDetail.metricName}'
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
            name: metricDetail.metricName
            metricNamespace: 'microsoft.insights/components'
            metricName: metricDetail.metricIdentifier
            operator: 'GreaterThan'
            timeAggregation: 'Count'
            criterionType: 'StaticThresholdCriterion'
          }
        ]
      }
    }
  }
]

/*
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
*/
