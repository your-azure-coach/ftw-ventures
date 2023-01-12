// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param apimName string
param displayName string = name
param description string = 'Azure AD Group ${name}'
param aadGroupObjectId string

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Describe group
resource apimGroup 'Microsoft.ApiManagement/service/groups@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    displayName: displayName
    description: description
    type: 'external'
    externalId: 'aad://${tenant().tenantId}/groups/${aadGroupObjectId}'
  }
}
