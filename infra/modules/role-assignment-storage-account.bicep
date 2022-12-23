// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'Storage Account Backup Contributor'
  'Storage Account Contributor'
  'Storage Account Key Operator Service Role'
  'Storage Blob Data Contributor'
  'Storage Blob Data Owner'
  'Storage Blob Data Reader'
  'Storage Blob Delegator'
  'Storage File Data SMB Share Contributor'
  'Storage File Data SMB Share Elevated Contributor'
  'Storage File Data SMB Share Reader'
  'Storage Queue Data Contributor'
  'Storage Queue Data Message Processor'
  'Storage Queue Data Message Sender'
  'Storage Queue Data Reader'
  'Storage Table Data Contributor'
  'Storage Table Data Reader'
])
param roleName string
param storageAccountName string
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
  'Storage Account Backup Contributor': resourceId('Microsoft.Authorization/roleAssignments', 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1')
  'Storage Account Contributor': resourceId('Microsoft.Authorization/roleAssignments', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Storage Account Key Operator Service Role': resourceId('Microsoft.Authorization/roleAssignments', '81a9662b-bebf-436f-a333-f67b29880f12')
  'Storage Blob Data Contributor': resourceId('Microsoft.Authorization/roleAssignments', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  'Storage Blob Data Owner': resourceId('Microsoft.Authorization/roleAssignments', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')
  'Storage Blob Data Reader': resourceId('Microsoft.Authorization/roleAssignments', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
  'Storage Blob Delegator': resourceId('Microsoft.Authorization/roleAssignments', 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a')
  'Storage File Data SMB Share Contributor': resourceId('Microsoft.Authorization/roleAssignments', '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb')
  'Storage File Data SMB Share Elevated Contributor': resourceId('Microsoft.Authorization/roleAssignments', 'a7264617-510b-434b-a828-9731dc254ea7')
  'Storage File Data SMB Share Reader': resourceId('Microsoft.Authorization/roleAssignments', 'aba4ae5f-2193-4029-9191-0cb91df5e314')
  'Storage Queue Data Contributor': resourceId('Microsoft.Authorization/roleAssignments', '974c5e8b-45b9-4653-ba55-5f855dd0fb88')
  'Storage Queue Data Message Processor': resourceId('Microsoft.Authorization/roleAssignments', '8a0f0c08-91a1-4084-bc3d-661d67233fed')
  'Storage Queue Data Message Sender': resourceId('Microsoft.Authorization/roleAssignments', 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a')
  'Storage Queue Data Reader': resourceId('Microsoft.Authorization/roleAssignments', '19e7f393-937e-4f77-808e-94535e297925')
  'Storage Table Data Contributor': resourceId('Microsoft.Authorization/roleAssignments', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3')
  'Storage Table Data Reader': resourceId('Microsoft.Authorization/roleAssignments', '76199698-9eea-4c19-bc75-cec21354c6b6')
  }

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(storageAccount.id, principalId, roleIds[roleName])
  scope: storageAccount
  properties: {
    roleDefinitionId: roleIds[roleName]
    principalId: principalId
    principalType: principalType
  }
}
