// PARAMETERS
param resourceLocation string

// RESOURCES
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'aspfa-test-ps-bicep-cla'
  location: resourceLocation
}
