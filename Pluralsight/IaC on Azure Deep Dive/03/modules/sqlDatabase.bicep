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
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: adminManagedIdentityName
      sid: adminManagedIdentityClientId
      tenantId: subscription().tenantId
    }
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: '${companyName}-Database'
  location: resourceLocation
  sku: {
    name: 'Basic'
  }
}
