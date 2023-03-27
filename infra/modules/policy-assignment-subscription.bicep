// Scope
targetScope = 'subscription'

// Parameters
param definition object
param definitionId string
param parameters object
param nonComplianceMessage string = ''
param location string

// Resources
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: guid(definition.id)
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: definition.properties.description
    displayName: definition.properties.displayName
    policyDefinitionId: definitionId
    parameters: parameters
    nonComplianceMessages: [
      {
        message: nonComplianceMessage
      }
    ]
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (contains(definition.properties.policyRule.then, 'details') && contains(definition.properties.policyRule.then.details, 'roleDefinitionIds')) {
  name: guid(policyAssignment.name)
  properties: {
    roleDefinitionId: definition.properties.policyRule.then.details.roleDefinitionIds[0]
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
