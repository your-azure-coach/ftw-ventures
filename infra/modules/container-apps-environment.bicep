// Scope
targetScope = 'resourceGroup'

param name string
param location string = resourceGroup().location
param logAnalyticsWorkspaceId string
param enablePrivateAccess bool
param subnetId string = ''

// Resource
resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsWorkspaceId, '2021-12-01-preview').customerId
        sharedKey: listKeys(logAnalyticsWorkspaceId, '2021-12-01-preview').primarySharedKey
      }
    }
    vnetConfiguration: {
        internal: enablePrivateAccess
        infrastructureSubnetId: subnetId
    }    
  }
}

output id string = containerAppsEnvironment.id
output name string = containerAppsEnvironment.name
