// PARAMETERS
param resourceLocation string
param productName string
param spokeNumber string
param connectivityRgName string
param hubNetworkName string



// VARIABLES
var spokeNetworkName = 'vnet-${productName}'



// RESOURCES

resource hubNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = { // calling the previously created Hub VNET
  name: hubNetworkName
  scope: resourceGroup(connectivityRgName)
}


resource spokeNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = { // creating Spoke VNET
  name: spokeNetworkName
  location: resourceLocation
  properties: {
    addressSpace: {
      addressPrefixes:[
        '10.11.${spokeNumber}.0/24'
      ]
    }
    // won't create any Subnets as those will be created by the Team that will use the deployed new Landing Zone
  }
}


// creating peering from the Spoke to the Hub network
resource peeringSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'spoke_to_hub'
  parent: spokeNetwork
  properties: {
    remoteVirtualNetwork: {
      id:hubNetwork.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}



// MODULES
// creating peering from the Hub to the the Spoke network needs to be done in another file as the Hub Network resource is in another scope
module peeringHubToSpoke 'hub-to-spoke-peering.bicep' = {
  name: 'peeringHubToSpokeDeployment'
  scope: resourceGroup(connectivityRgName) // need to deploy the module in the RG that contains the Hub VNET
  params: {
    hubNetworkName: hubNetworkName
    spokeNetworkName: spokeNetworkName
    spokeRgName: resourceGroup().name
    spokeNumber: spokeNumber
  }
}


// Also creating a Route Table resource
resource  routeTable 'Microsoft.Network/routeTables@2024-01-01' = {
  name: 'defaultRouteTable'
  location: resourceLocation
  properties: {
    disableBgpRoutePropagation: true //disable BGP route propagation in order to ensure that only custom routes are used
    routes: [{
      name: 'defaultRoute'
      properties: {
        addressPrefix: '0.0.0.0/0' // determines to which traffic this route applies; 0.0.0.0/0 means all traffic
        hasBgpOverride: false // BGP override not possible
        nextHopIpAddress: '10.10.10.4' // Firewall IP address
        nextHopType: 'VirtualAppliance'
      }
    }]
  }
}
