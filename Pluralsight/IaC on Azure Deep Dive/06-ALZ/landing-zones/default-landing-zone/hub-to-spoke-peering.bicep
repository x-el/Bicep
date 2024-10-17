// PARAMETERS
param hubNetworkName string
param spokeNetworkName string
param spokeRgName string
param spokeNumber string



// RESOURCES


// Existing Hub Network reference (default RG deployment location)
resource hubNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: hubNetworkName
}

// Existing Spoke Network reference
resource spokeNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: spokeNetworkName
  scope: resourceGroup(spokeRgName)
}

// creating peering from the Hub to the Spoke network
resource peeringHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: 'hub_to_spoke-${spokeNumber}'
  parent: hubNetwork
  properties: {
    remoteVirtualNetwork: {
      id:spokeNetwork.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
