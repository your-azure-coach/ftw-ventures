// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'App Configuration Data Owner'
  'App Configuration Data Reader'
])
param roleName string
param appConfigurationName string
param principalId string
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string

// variables
var roleIds = {
  'App Configuration Data Owner': resourceId('Microsoft.Authorization/roleAssignments', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b')
  'App Configuration Data Reader': resourceId('Microsoft.Authorization/roleAssignments', '516239f1-63e1-4d78-a4de-a74fb236a071')
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' existing = {
  name: appConfigurationName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(appConfiguration.id, principalId, roleIds[roleName])
  scope: appConfiguration
  properties: {
    roleDefinitionId: roleIds[roleName]
    principalId: principalId
    principalType: principalType
  }
}
