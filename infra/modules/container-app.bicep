// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param environmentId string
param userAssignedIdentityId string
param containerRegistryServer string
param requiresHttpsIngress bool
@allowed([ 'Single', 'Multiple' ])
param revisionMode string
param allowPublicAccess bool
param containerAppTemplate object


resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}': {}
    }
  }
  properties: {
    environmentId: environmentId
    configuration: {
      ingress: (requiresHttpsIngress) ? {
        allowInsecure: false
        external: allowPublicAccess
        targetPort: 80
        transport: 'http'
      } : null
      activeRevisionsMode: revisionMode
      registries: [
        {
          identity: userAssignedIdentityId
          server: containerRegistryServer
        }
      ]
    }
    template: containerAppTemplate
  }
}
