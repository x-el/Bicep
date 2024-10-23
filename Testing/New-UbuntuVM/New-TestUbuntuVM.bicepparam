using 'New-TestUbuntuVM.bicep'



// PARAMETERS

@description('The name of the target Resource Group.')
param resourceGroupName = 'Test-Learn-Bicep-WE'

@description('The name of the network infrastructure Resource Group.')
param networkResourceGroupName = 'Test-Core-Net-WE'

@description('The name of your Virtual Machine.')
param vmName  = 'UbuntuVM'

@description('Username for the Virtual Machine.')
param adminUsername =

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType  = 'password'

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
param ubuntuOSVersion = 'Ubuntu-2204'

@description('The size of the VM')
param vmSize = 'Standard_B2s'

@description('Name of the VNET')
param virtualNetworkName = 'Test-WE-VNet01'

@description('Name of the Network Security Group')
param networkSecurityGroupName = 'ASPFA-Test-WE-NSG'

@description('Security Type of the Virtual Machine.')
param securityType = 'TrustedLaunch'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
param adminPasswordOrKey = az.getSecret(subscriptionId,resourceGroupName,passwordAkvName,passwordSecretName)



// VARIABLES 

var passwordAkvName = 'aspfatestbicepwest'
var passwordSecretName = 'ubuntu-vm-password'
var subscriptionId = '3b4e37d3-b3bc-4d14-b7cc-542c313518f7' 
