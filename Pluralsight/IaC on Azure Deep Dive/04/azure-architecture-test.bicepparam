using 'azure-architecture.bicep'

param environmentName = 'test'
param websiteConfigurationSettings = {
  awesomeFeatureCount: 2
  awesomeFeatureDisplayName: 'Feature Three'
  awesomeFeatureEnabled: true
}
