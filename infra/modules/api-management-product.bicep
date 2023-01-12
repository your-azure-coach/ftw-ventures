// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param displayName string = name
param description string = ''
param apimName string
param apis array = []
param groups array = []
param requiresSubscription bool = true
param requiresApproval bool = true

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Describe product
resource apimProduct 'Microsoft.ApiManagement/service/products@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    displayName: displayName
    description: description
    state: 'published'
    approvalRequired: requiresApproval
    subscriptionRequired: requiresSubscription
  }
}

//Describe groups for access control
resource apimProductGroup 'Microsoft.ApiManagement/service/products/groups@2022-04-01-preview' = [for group in groups: {
  name: group
  parent: apimProduct
}]

//Describe related APIs
resource apimProductApi 'Microsoft.ApiManagement/service/products/apis@2022-04-01-preview' = [for api in apis: {
  name: api
  parent: apimProduct
}]
