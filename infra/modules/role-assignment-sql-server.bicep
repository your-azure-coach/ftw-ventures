// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'SQL Server Contributor'
])
param roleName string
param sqlServerName string
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
  'SQL Server Contributor': resourceId('Microsoft.Authorization/roleAssignments', '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437')
  }

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: sqlServerName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(sqlServer.id, principalId, roleIds[roleName])
  scope: sqlServer
  properties: {
    roleDefinitionId: roleIds[roleName]
    principalId: principalId
    principalType: principalType
  }
}
