using 'azure-architecture-CDT.bicep'

param environmentName = 'prod'
param websiteConfigurationSettings = {
  awesomeFeatureCount: 3
  awesomeFeatureDisplayName: 'Feature Two'
  awesomeFeatureEnabled: true
}
