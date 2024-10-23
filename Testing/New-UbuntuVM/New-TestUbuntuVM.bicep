// PARAMETERS

@description('The name of the network infrastructure Resource Group.')
param networkResourceGroupName string = 'Test-Core-Net-WE'

@description('The name of your Virtual Machine.')
param vmBaseName string

@description('Username for the Virtual Machine.')
param adminUsername string

@description('The size of the VM')
param vmSize string = 'Standard_B2s'

@description('Name of the VNET')
param virtualNetworkName string = 'Test-WE-VNet01'

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'ASPFA-Test-WE-NSG'

@description('Using the current time to generate an unique VM name')
param currentTime string = utcNow('HHmmss')



// VARIABLES

// var randomString = uniqueString(vmBaseName)
// var randomShortString = substring(randomString,0,6)
var vmName = '${vmBaseName}-${currentTime}'
var publicIPAddressName = '${vmName}-PublicIP'
var dnsLabelPrefix = toLower('${vmName}-${uniqueString(resourceGroup().id)}')
var networkInterfaceName = '${vmName}-VNIC'
var networkInterfaceId = networkInterface.id
var resourceLocation = resourceGroup().location
var passwordAkvName = 'aspfatestbicepwest'
var passwordSecretName = 'ubuntu-vm-password'



// RESOURCES

resource passwordKeyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: passwordAkvName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(networkResourceGroupName)
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' existing = {
  name: networkSecurityGroupName
  scope: resourceGroup(networkResourceGroupName)
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIPAddressName
  location: resourceLocation
  tags: resourceGroup().tags
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: networkInterfaceName
  location: resourceLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}



// MODULES

module ubuntuVmModule 'modules/ubuntuVM.bicep' = {
  name: 'ubuntuVM'
  params: {
    adminUsername: adminUsername
    vmName: vmName
    vmSize: vmSize
    networkInterfaceId: networkInterfaceId
    adminPasswordOrKey: passwordKeyVault.getSecret(passwordSecretName)
  }
}



// OUTPUTS

output adminUsername string = adminUsername
output hostname string = publicIPAddress.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'
output generatedVmName string = vmName
