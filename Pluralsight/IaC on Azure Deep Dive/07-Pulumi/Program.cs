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
    

    // Create VM
});