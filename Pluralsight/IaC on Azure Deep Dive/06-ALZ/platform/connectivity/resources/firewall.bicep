// PARAMETERS
param resourceLocation string
param virtualNetworkName string
param firewallSubnetName string
param logAnalyticsWorkspaceName string
param managementRgName string



// RESOURCES

resource firewallPublicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = { // Public IP creation
  name: 'firewall-pip'
  location: resourceLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = { // calling the existing/previously created VNET
  name: virtualNetworkName
  resource firewallSubnet 'subnets@2024-01-01' existing = {
    name: firewallSubnetName
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2024-01-01' = { // Firewall resource creation
  name: 'firewall'
  location: resourceLocation
  properties: {
    ipConfigurations: [{
      name: 'ipConfiguration'
      properties: {
        subnet: {
          id: virtualNetwork::firewallSubnet.id
        }
        publicIPAddress: {
          id: firewallPublicIp.id
        }
      }
    }]
    networkRuleCollections: [{
      name: 'LZ101Rules'
      properties: {
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [{
          name: 'allow-outbound-to-internet'
          protocols: ['any']
          sourceAddresses: ['10.1.101.4']
          destinationAddresses: ['*']
          destinationPorts: ['*']
        }]
      }
    }]
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = { // reference the previously created LAW
  name: logAnalyticsWorkspaceName
  scope: resourceGroup(managementRgName)
}

resource firewallDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = { // create Diagnostic Settings extension resource
  name: 'allLogs_to_LAW'
  scope: firewall
  properties: {
    logs: [{
      categoryGroup: 'allLogs'
      enabled: true
    }]
    logAnalyticsDestinationType: 'Dedicated'
    workspaceId:logAnalyticsWorkspace.id
  }
}
