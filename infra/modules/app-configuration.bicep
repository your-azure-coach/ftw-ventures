// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'standard'
])
param sku string
param name string
param location string
param enableSoftDelete bool
param allowPublicAccess bool
param enablePrivateAccess bool
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
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: false //https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-disable-access-key-authentication?tabs=portal#arm-template-access 
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    enablePurgeProtection: enableSoftDelete
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
