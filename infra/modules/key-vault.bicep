// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'standard'
  'premium'
])
param sku string
param name string
param location string
param enableSoftDelete bool = true
param allowPublicAccess bool 
param allowAzureServices bool
param enablePrivateAccess bool
param subnetId string = ''
param endpointName string = '${name}-endpoint'
param deploymentId string


// Resources
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: sku
    }
    tenantId: tenant().tenantId
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    enabledForDeployment: allowAzureServices
    enabledForTemplateDeployment: allowAzureServices
    enableRbacAuthorization: true
    enableSoftDelete: enableSoftDelete 
  }
}

module privateEndpoint 'private-endpoint.bicep' = if (enablePrivateAccess) {
  name: 'pe-${take(name,24)}-${deploymentId}'
  params: {
    name: endpointName
    resourceId: keyVault.id
    resourceType: 'KeyVault'
    subnetId: subnetId
    location: location
  }
}

output name string = keyVault.name
output uri string = keyVault.properties.vaultUri
