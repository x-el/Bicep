resource serverFarm 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'testServerFarm'
  location: 'westeurope'
  sku:{
    name: 'S1'
  }
}

resource website 'Microsoft.Web/sites@2023-12-01' = {
  name: 'fakeCompanyPortal-hb'
  location: 'westeurope'
  // dependsOn: [ serverFarm ]
  properties: {
    serverFarmId:serverFarm.id
  }
}

resource websiteSettings 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: website // could have also included the websiteSettings resource directly in the website one instead
  name: 'appsettings'
  properties: {
    enableAwesomeFeature: 'true'
  }
}

// can also add notes like this
/*
  Or like this
*/
