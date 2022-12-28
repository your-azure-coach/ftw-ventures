// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
@allowed([
  'Basic_C0'
  'Basic_C1'
  'Basic_C2'
  'Basic_C3'
  'Basic_C4'
  'Basic_C5'
  'Basic_C6'
  'Standard_C0'
  'Standard_C1'
  'Standard_C2'
  'Standard_C3'
  'Standard_C4'
  'Standard_C5'
  'Standard_C6'
  'Premium_P1'
  'Premium_P2'
  'Premium_P3'
  'Premium_P4'
  'Premium_P5'
])
param sku string
param location string
param userAssignedIdentityId string
param allowPublicAccess bool 
param enablePrivateAccess bool
param keyVaultName string
param redisConnectionStringSecretName string = 'REDIS--CONNECTIONSTRING'
param subnetId string = ''
param endpointName string = '${name}-endpoint'
param deploymentId string


// Resource
resource redisCache 'Microsoft.Cache/redis@2022-06-01' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}' : {}
    }
  }
  properties: {
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    redisVersion: 'latest'
    sku: {
      family: substring(split(sku, '_')[1], 0, 1)
      capacity: int(substring(split(sku, '_')[1], 1, 1))
      name: split(sku, '_')[0]
    }
  }
}

module redisCacheConnectionStringKeyVault '../modules/key-vault-secret.bicep' = if (keyVaultName != '') {
  name: 'ks-${take(guid(keyVaultName, redisCache.id), 24)}-${deploymentId}'
  params: {
    name: redisConnectionStringSecretName
    value: '${redisCache.properties.hostName},abortConnect=false,ssl=true,allowAdmin=true,password=${listKeys(redisCache.id, redisCache.apiVersion).primaryKey}'
    keyVaultName: keyVaultName
  }
}

module privateEndpoint 'private-endpoint.bicep' = if (enablePrivateAccess) {
  name: 'pe-${take(name,24)}-${deploymentId}'
  params: {
    name: endpointName
    resourceId: redisCache.id
    resourceType: 'Redis'
    subnetId: subnetId
    location: location
  }
}

output name string = name
output connectionStringSecretUri string = redisCacheConnectionStringKeyVault.outputs.uri
output connectionStringSecretVersionedUri string = redisCacheConnectionStringKeyVault.outputs.versionedUri
