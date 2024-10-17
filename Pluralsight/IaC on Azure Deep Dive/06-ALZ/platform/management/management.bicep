// PARAMETERS
param resourceLocation string
param logAnalayticsWorkspaceName string 

// RESOURCES
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalayticsWorkspaceName
  location: resourceLocation
}
