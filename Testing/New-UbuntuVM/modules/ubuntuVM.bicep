// PARAMETERS

param networkInterfaceId string

@description('The size of the VM')
param vmSize string = 'Standard_B2s'

@description('The name of your Virtual Machine.')
param vmName string = 'UbuntuVM'

@description('Username for the Virtual Machine.')
param adminUsername string

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string


// VARIABLES

var authenticationType = 'password'

var imageReference = {
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}

var ubuntuOSVersion = 'Ubuntu-2204'
var securityType  = 'TrustedLaunch'
var osDiskName = '${vmName}-OsDisk'
var osDiskType = 'Standard_LRS'

var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}

var extensionName = 'GuestAttestation'
var extensionPublisher = 'Microsoft.Azure.Security.LinuxAttestation'
var extensionVersion = '1.0'
var maaTenantName = 'GuestAttestation'
var maaEndpoint = substring('emptystring', 0, 0)
var resourceLocation = resourceGroup().location



// RESOURCES

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: resourceLocation
  tags: resourceGroup().tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        name: osDiskName
      }
      imageReference: imageReference[ubuntuOSVersion]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceId
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
    securityProfile: (securityType == 'TrustedLaunch') ? securityProfileJson : null
  }
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = if (securityType == 'TrustedLaunch' && securityProfileJson.uefiSettings.secureBootEnabled && securityProfileJson.uefiSettings.vTpmEnabled) {
  parent: vm
  name: extensionName
  location: resourceLocation
  properties: {
    publisher: extensionPublisher
    type: extensionName
    typeHandlerVersion: extensionVersion
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: maaEndpoint
          maaTenantName: maaTenantName
        }
      }
    }
  }
}
