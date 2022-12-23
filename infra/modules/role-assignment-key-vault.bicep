// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'Key Vault Administrator'
  'Key Vault Certificates Officer'
  'Key Vault Contributor'
  'Key Vault Crypto Officer'
  'Key Vault Crypto Service Encryption User'
  'Key Vault Crypto User'
  'Key Vault Reader'
  'Key Vault Secrets Officer'
  'Key Vault Secrets User'
])
param roleName string
param keyVaultName string
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
  'Key Vault Administrator': resourceId('Microsoft.Authorization/roleAssignments', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
  'Key Vault Certificates Officer': resourceId('Microsoft.Authorization/roleAssignments', 'a4417e6f-fecd-4de8-b567-7b0420556985')
  'Key Vault Contributor': resourceId('Microsoft.Authorization/roleAssignments', 'f25e0fa2-a7c8-4377-a976-54943a77a395')
  'Key Vault Crypto Officer': resourceId('Microsoft.Authorization/roleAssignments', '14b46e9e-c2b7-41b4-b07b-48a6ebf60603')
  'Key Vault Crypto Service Encryption User': resourceId('Microsoft.Authorization/roleAssignments', 'e147488a-f6f5-4113-8e2d-b22465e65bf6')
  'Key Vault Crypto User': resourceId('Microsoft.Authorization/roleAssignments', '12338af0-0e69-4776-bea7-57ae8d297424')
  'Key Vault Reader': resourceId('Microsoft.Authorization/roleAssignments', '21090545-7ca7-4776-b22c-e363652d74d2')
  'Key Vault Secrets Officer': resourceId('Microsoft.Authorization/roleAssignments', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  'Key Vault Secrets User': resourceId('Microsoft.Authorization/roleAssignments', '4633458b-17de-408a-b874-0445c86b69e6')
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(keyVault.id, principalId, roleIds[roleName])
  scope: keyVault
  properties: {
    roleDefinitionId: roleIds[roleName]
    principalId: principalId
    principalType: principalType
  }
}
