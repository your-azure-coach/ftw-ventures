// Scope
targetScope = 'subscription'

// Parameters
param name string
param location string
param tags object = {}
param roleAssignments array = []
param budgetAlerts array = []
param deploymentId string

// Define resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
  tags: tags
}

// Configure role assignments
module rgRoleAssignments 'role-assignment-resource-group.bicep' = [for roleAssignment in roleAssignments: {
  scope: resourceGroup
  name: 'rg-ra-${take(guid(resourceGroup.id, roleAssignment.principalId, roleAssignment.role), 43)}-${deploymentId}'
  params: {
    principalId: roleAssignment.principalId
    principalType: roleAssignment.principalType
    roleName: roleAssignment.role
  }
}]

// Configure budget alerts
module rgBudgetAlerts 'budget-alert-resource-group.bicep' = [for budgetAlert in budgetAlerts: {
  scope: resourceGroup
  name: 'rg-ba-${take(budgetAlert.name, 44)}-${deploymentId}'
  params: {
    name: budgetAlert.name
    budget: budgetAlert.budget
    emailAddresses: budgetAlert.emailAddresses
  }
}]

// Outputs
output id string = resourceGroup.id
output name string = resourceGroup.name
