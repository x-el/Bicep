using Pulumi;
using Pulumi.AzureNative.Resources;
using Pulumi.AzureNative.Storage;
using Pulumi.AzureNative.Storage.Inputs;
using System.Collections.Generic;

return await Pulumi.Deployment.RunAsync(() =>
{
    // Create an Azure Resource Group
    // var resourceGroup = new ResourceGroup("resourceGroup");
    // Reference an existing Azure RG
    var resourceGroup = new Pulumi.AzureNative.Resources.ResourceGroup(
        "resourceGroup", new( {
                ResourceGroupName = "Test-PS-Bicep-103-product3"
            }
        ), new() {
            ImportId = "/subscriptions/3b4e37d3-b3bc-4d14-b7cc-542c313518f7/resourceGroups/Test-PS-Bicep-103-product3" // RG Resource ID
        }
    );

    // Create subnet
    var subnet = new Pulumi.AzureNative.Network.subnet("subnet", new() {
        addressPrevix = "10.11.103.0/24",
        ResourceGroupName = resourceGroup.Name,
        SubnetName = "default"
    });

    // Create VNIC
    var networkInterface = new Pulumi.AzureNative.Network.networkInterface("network-interface", new(){
        ResourceGroupName = ResourceGroup.Name,
        IpConfigurations = new[] {
            new Pulumi.AzureNative.Netowrk.Inputs.NetworkInterfaceIPConfigurationArgs {
                nameof = "pulumi-nic-ipconfiguration",
                PrivateIPAllocationMethod = Pulumi.AzureNative.PrivateIPAllocationMethod.Dynamic,
                subnet = new Pulumi.AzureNative.Network.Inputs.SubnetArgs {
                    Id = subnet.Id
                }
            }
        }
    });

    // Create VM
    var vm = new Pulumi.AzureNative.Compute.VirtualMachine ("vm", new(){
        ResourceGroupName = ResourceGroup.Name,
        NetworkProfile = new Pulumi.AzureNativeCompute.Inputs.NetworkProfileArgs {
            networkInterfaces = new[] {
                new Pulumi.AzureNative.Compute.Inputs.NetworkInterfaceIPConfigurationArgs {
                    id = networkInterface.Id,
                    Primary = true
                },
            },
        },

        HardwareProfile = new Pulumi.AzureNative.Compute.Inputs.HardwareProfileArgs {
            VmSize = "Standard_B2s"
        },

        OsProfile = new Pulumi.AzureNative.Compute.Inputs.OsProfileArgs {
            ComputerName = "pulumi-vm"
            AdminUsername = "babasha"
            AdminPassword = new Pulumi.Random.RandomPassword("password", new() {
                Length = 16,
                Special = true
            }).Result
        },

        StorageProfile = new Pulumi.AzureNative.Compute.Input.StorageProfileArgs {
            OsDisk = new Pulumi.AzureNative.Compute.Inputs.OsDiskARgs {
                Name = "pulumi-vm-osdisk"
                CreateOption = Pulumi.AzureNative.Compute.DiskCreateOptionTypes.FromImage,
            },
            ImageReference = new Pulumi.AzureNative.Compute.Inputs.ImageReferenceArgs {
                Publisher = "MicrosoftWIndowsServer",
                Offer = "WindowsServer",
                Sku = "2022-datacenter-azure-edition",
                Version = "latest",
            },
        },
    });
});