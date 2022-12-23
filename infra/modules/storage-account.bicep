// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param sku string
param name string
param location string = resourceGroup().location
param allowPublicAccess bool 
param enablePrivateAccess bool
param isDataLakeStore bool = false
param subnetId string = ''
param blobContainers array = []
param endpointName string = '${name}-endpoint'
param deploymentId string
param isVersioningEnabled bool = false
param privateIpAddress string = ''
param enforceAzureAdAuth bool = true

// Resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: !enforceAzureAdAuth
    isHnsEnabled: isDataLakeStore
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name:  'default'
  parent: storageAccount
  properties: {
    isVersioningEnabled: isVersioningEnabled
  }
  resource containers 'containers' = [for container in blobContainers: {
    name: container.name
    properties: {
      publicAccess: 'None'
    }
  }]
}

module privateEndpoint 'private-endpoint.bicep' = if(enablePrivateAccess) {
  name: 'pe-${take(name,24)}-${deploymentId}'
  params: {
    name: endpointName
    resourceId: storageAccount.id
    resourceType: isDataLakeStore ? 'DataLakeStore' : 'BlobStorage'
    subnetId: subnetId
    location: location
    privateIpAddress: privateIpAddress
  }
}

output name string = storageAccount.name
