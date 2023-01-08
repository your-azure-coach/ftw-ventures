// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string 
param resourceId string
@allowed([
  'KeyVault'
  'ContainerRegistry'
  'DataExplorer'
  'DigitalTwin'
  'IoTHub'
  'ServiceBus'
  'DataLakeStore'
  'BlobStorage'
  'AppConfiguration'
  'DataFactory'
  'EventGrid'
  'SqlServer'
  'EventHubs'
  'Redis'
])
param resourceType string
param subnetId string
param privateIpAddress string = ''
