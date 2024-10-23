using 'New-TestUbuntuVM.bicep'



// PARAMETERS

@description('The name of the network infrastructure Resource Group.')
param networkResourceGroupName = 'Test-Core-Net-WE'

@description('The name of your Virtual Machine.')
param vmBaseName  = 'UbuntuVM'

@description('Username for the Virtual Machine.')
param adminUsername = 'gica'

@description('The size of the VM')
param vmSize = 'Standard_B2s'

@description('Name of the VNET')
param virtualNetworkName = 'Test-WE-VNet01'

@description('Name of the Network Security Group')
param networkSecurityGroupName = 'ASPFA-Test-WE-NSG'



// VARIABLES 
