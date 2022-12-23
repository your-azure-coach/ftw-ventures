// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'standard'
])
param sku string
param name string
param location string
param userAssignedIdentityId string
param allowPublicAccess bool
param enablePrivateAccess bool
param enforceAzureAdAuth bool = true
param subnetId string = ''
param endpointName string = '${name}-endpoint'
param deploymentId string

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}' : {}
    }
  }
  properties: {
    disableLocalAuth: enforceAzureAdAuth 
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
  }
}

module privateEndpoint 'private-endpoint.bicep' = if(enablePrivateAccess) {
  name: 'pe-${take(name,47)}-${deploymentId}'
  params: {
    name: endpointName
    resourceId: appConfiguration.id
    resourceType: 'AppConfiguration' 
    subnetId: subnetId
    location: location
  }
}

output name string = appConfiguration.name
output uri string = 'https://${appConfiguration.name}.azconfig.io'
