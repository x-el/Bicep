// CUSTOM DATA TYPES



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



// IMPORTING CDT's

import { websiteConfigurationSettingsType } from 'modules/appService.bicep'



// MODULES

module applicationInsightsModule 'ts/aspfa:applicationInsights:1.1' = {
  name: 'applicationInsights' // each module Deployment needs a name, because the module will translate into an individual Deployment in Azure
  params: {
      environmentName: environmentName
      resourceLocation: resourceLocation
      resourceName: resourceName
      metricsPublisherPrincipalId: appServiceModule.outputs.websiteManagedIdentityPrincipalId
    }
}

module appServiceModule 'br/aspfa:bicep/modules/appservice:v1' = {
  name: 'appServiceDeploment'
  params: {
    aspTier: aspTier
    resourceLocation: resourceLocation
    resourceName: resourceName
    environmentName: environmentName
    websiteConfigurationSettings: websiteConfigurationSettings
  }
}

module sqlDatabaseModule 'ts/aspfa:sqlDatabase:1.0' = {
name: 'sqlDatabaseDeployment'
params: {
  environmentName: environmentName
  resourceLocation: resourceLocation
  companyName: companyName
  adminManagedIdentityName: appServiceModule.outputs.websiteManagedIdentityName
  adminManagedIdentityClientId: appServiceModule.outputs.websiteManagedIdentityClientId
  }
}



// RESOURCES




// can also add notes like this
/*
  Or like this
*/
