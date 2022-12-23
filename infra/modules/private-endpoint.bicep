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

// Get Shared Parameters - discussed that using shared parameters in this module will make life much easier
// var sharedParameters = loadJsonContent('../platform-parameters.json')
// var privateDnsZoneSubscriptionId = sharedParameters.subscriptions[sharedParameters.platformResources.privateDnsZones.environment]
// var privateDnsZoneResourceGroupName = sharedParameters.platformResources.privateDnsZones.resourceGroup

// // Variables
// var pveValues = {
//   KeyVault: {
//     groupId : 'vault'
//     privateDnsZone : 'privatelink.vaultcore.azure.net'
//   } 
//   ContainerRegistry: {
//     groupId : 'registry'
//     privateDnsZone : 'privatelink.azurecr.io'
//   }
//   DataExplorer : {
//     groupId : 'cluster'
//     privateDnsZone : ''
//   }
//   DigitalTwin : {
//     groupId : 'API'
//     privateDnsZone : 'privatelink.digitaltwins.azure.net'
//   }
//   IoTHub : {
//     groupId : 'iothub'
//     privateDnsZone : 'privatelink.azure-devices.net'
//   }
//   ServiceBus : {
//     groupId : 'namespace'
//     privateDnsZone : 'privatelink.servicebus.windows.net'
//   }
//   DataLakeStore : {
//     groupId : 'dfs'
//     privateDnsZone : 'privatelink.dfs.core.windows.net'
//   }
//   BlobStorage : {
//     groupId : 'blob'
//     privateDnsZone : 'privatelink.blob.core.windows.net'
//   }
//   AppConfiguration : {
//     groupId : 'configurationStores'
//     privateDnsZone : 'privatelink.azconfig.io'
//   }
//   SqlServer : {
//     groupId : 'sqlServer'
//     privateDnsZone : 'privatelink.database.windows.net'
//   }
//   DataFactory : {
//     groupId : 'dataFactory'
//     privateDnsZone : 'privatelink.datafactory.azure.net'
//   }
//   EventGrid : {
//     groupId : 'topic'
//     privateDnsZone : 'privatelink.eventgrid.azure.net'
//   }
//   EventHubs : {
//     groupId : 'namespace'
//     privateDnsZone : 'privatelink.servicebus.windows.net'
//   }
//   Redis : {
//     groupId : 'redisCache'
//     privateDnsZone : 'privatelink.redis.cache.windows.net'
//   }
// }

// var groupId = pveValues[resourceType].groupId
// var privateDnsZoneName = pveValues[resourceType].privateDnsZone


// // Resources
// resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
//   scope: resourceGroup(privateDnsZoneSubscriptionId, privateDnsZoneResourceGroupName)
//   name: privateDnsZoneName
// }

// resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
//   name: name
//   location: location
//   properties: {
//     subnet: {
//       id: subnetId
//     }
//     ipConfigurations: privateIpAddress == '' ? null : [{
//       name: name
//       properties: {
//         privateIPAddress: privateIpAddress
//         groupId: groupId
//         memberName: groupId
//       }
//     }]
//     privateLinkServiceConnections: [
//       {
//         name: name
//         properties: {
//           privateLinkServiceId: resourceId
//           groupIds: [
//             groupId
//           ]
//         }
//       }
//     ]
//   }
// }

// resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = if (privateDnsZoneName != '') {
//   name: 'default'
//   parent: privateEndpoint
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: privateDnsZoneName
//         properties: {
//           privateDnsZoneId: privateDnsZone.id
//         }
//       }
//     ]
//   }
// }
