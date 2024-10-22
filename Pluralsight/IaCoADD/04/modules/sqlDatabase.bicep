// PARAMETERS

param environmentName string
param resourceLocation string
param companyName string
param adminManagedIdentityName string
param adminManagedIdentityClientId string



// RESOURCES

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: '${companyName}-SqlServer-${environmentName}'
  location: resourceLocation
  tags: resourceGroup().tags
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: adminManagedIdentityName
      sid: adminManagedIdentityClientId
      // sid: '758ef29e-8134-453a-831d-e69f37b9e603' // manually specifying the UAMI Client ID
      // sid: '61b921d7-f38d-4947-9dc7-9ba1e9472560' // manually specifying the UAMI Object (principal) ID
      tenantId: subscription().tenantId
    }
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: '${companyName}-Database'
  location: resourceLocation
  tags: resourceGroup().tags
  sku: {
    name: 'Basic'
  }
}
