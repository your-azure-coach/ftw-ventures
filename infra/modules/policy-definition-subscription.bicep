// Scope
targetScope = 'subscription'

// Parameters
param definition object

// Resources
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: guid(definition.id)
  properties: {
    description: definition.properties.description
    displayName: definition.properties.displayName
    metadata: definition.properties.metadata
    mode: definition.properties.mode
    parameters: definition.properties.parameters
    policyType: definition.properties.policyType
    policyRule: definition.properties.policyRule
  }
}

//Outputs
output id string = policyDefinition.id
