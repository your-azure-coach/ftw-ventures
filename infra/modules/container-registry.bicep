// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
param sku string
param name string
param location string
param allowPublicAccess bool
param allowAzureServices bool
param enablePrivateAccess bool
param enableAdminUser bool = false
param subnetId string = ''
param endpointName string = '${name}-endpoint'
param deploymentId string

// Resource
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: enableAdminUser
    anonymousPullEnabled: false    
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    networkRuleBypassOptions: allowAzureServices ? 'AzureServices' : 'None'
  }
}

module privateEndpoint 'private-endpoint.bicep' = if(enablePrivateAccess) {
  name: 'pe-${take(name,24)}-${deploymentId}'
  params: {
    name: endpointName
    resourceId: containerRegistry.id
    resourceType: 'ContainerRegistry'
    subnetId: subnetId
    location: location
  }
}

output name string = containerRegistry.name
output serverName string = containerRegistry.properties.loginServer
