#############################################################################
# TERRAFORM CONFIG
#############################################################################
terraform {
    required_version = ">=1.8.4" // requiring terraform version 1.8.4 or newer
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
      }
      random = {
        source = "hashicorp/random"
        version = "~>3.0"
      }
    }
}


#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
  features {
  }
}



#############################################################################
# DATA
#############################################################################



#############################################################################
# VARIABLES
#############################################################################
variable "resourceLocation" {
  default = "westeurope"
}
variable "resourceGroupName" {
  default = "Test-PS-Bicep-102-product2"
}



#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_subnet" "virtualmachine_subnet" {
  name = "default"
  resource_group_name = var.resourceGroupName
  virtual_network_name = "vnet-product2"
  address_prefixes = ["10.11.102.0/24"]
}
resource "azurerm_network_interface" "virtualmachine_nic" {
  name = "ps-bicep-terraformVM-NIC"
  location = var.resourceLocation
  resource_group_name = var.resourceGroupName
  ip_configuration {
    name = "ps-bicep-terraformVM-NIC"
    subnet_id = azurerm_subnet.virtualmachine_subnet.id   // referencing a previously deployed resource
    private_ip_address_allocation = "Dynamic"
  }
}
resource "random_password" "password" {   // creating a randomly generated password
  length = 20
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
  special = true
}
resource "azurerm_windows_virtual_machine" "main" {    // create the VM itself
  name = "terraformVM"
  admin_username = "babasha"
  admin_password = random_password.password.result
  location = var.resourceLocation
  resource_group_name = var.resourceGroupName
  network_interface_ids = [ azurerm_network_interface.virtualmachine_nic.id ]
  size = "Standard_B2s"
  
  os_disk {
    name = "ps-bicep-terraformVM_os-disk"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-datacenter-azure-edition"
    version = "latest"
  }
}