// Scope
targetScope = 'subscription'

// Parameters
param tags object

// Define resources
resource subscriptionTags 'Microsoft.Resources/tags@2022-09-01' = {
  name: 'default'
  properties: {
    tags: tags
  }
}
