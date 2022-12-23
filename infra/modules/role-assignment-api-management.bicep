// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'API Management Developer Portal Content Editor'
  'API Management Service Contributor'
  'API Management Service Operator Role'
  'API Management Service Reader Role'
])
param roleName string
param apiManagementName string
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
  'API Management Developer Portal Content Editor': resourceId('Microsoft.Authorization/roleAssignments', 'c031e6a8-4391-4de0-8d69-4706a7ed3729')
  'API Management Service Contributor': resourceId('Microsoft.Authorization/roleAssignments', '312a565d-c81f-4fd8-895a-4e21e48d571c')
  'API Management Service Operator Role': resourceId('Microsoft.Authorization/roleAssignments', 'e022efe7-f5ba-4159-bbe4-b44f577e9b61')
  'API Management Service Reader Role': resourceId('Microsoft.Authorization/roleAssignments', '71522526-b88f-4d52-b57f-d31fc3546d0d')
}

resource apiManagementService 'Microsoft.ApiManagement/service@2021-12-01-preview' existing = {
  name: apiManagementName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(apiManagementService.id, principalId, roleIds[roleName])
  scope: apiManagementService
  properties: {
    roleDefinitionId: roleIds[roleName]
    principalId: principalId
    principalType: principalType
  }
}
