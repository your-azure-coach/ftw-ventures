//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get parameters
var parameters = loadJsonContent('./governance-parameters.json')
var sharedParameters = loadJsonContent('../infra-parameters.json')

//Set variables
var location = sharedParameters.regions.primary.location
var resourceGroupNames = items(sharedParameters.resourceGroups)
var subscriptionBudgetAlertName = replace(replace(sharedParameters.naming.budgetAlert, '{purpose}', 'subscription-budget'), '{env}', envName)
var enableSubscriptionBudgetAlert = contains(parameters[envKey], 'budgetAlerts') && contains(parameters[envKey].budgetAlerts, 'subscription')
var enableResourceGroupBudgetAlerts = contains(parameters[envKey], 'budgetAlerts') && contains(parameters[envKey].budgetAlerts, 'resourceGroups')
var enableSubscriptionTags = contains(parameters[envKey], 'tags') && contains(parameters[envKey].tags, 'subscription')
var enableResourceGroupTags = contains(parameters[envKey], 'tags') && contains(parameters[envKey].tags, 'resourceGroups')
var enableResourceGroupRoleAssignments = contains(parameters[envKey], 'roleAssignments') && contains(parameters[envKey].roleAssignments, 'resourceGroups')
var enableSubscriptionRoleAssignments = contains(parameters[envKey], 'roleAssignments') && contains(parameters[envKey].roleAssignments, 'subscription')

//Describe resource groups
module resourceGroups '../modules/resource-group.bicep' = [for resourceGroup in resourceGroupNames: {
  name: 'rg-${take(replace(resourceGroup.value, '{env}', envName),47)}-${deploymentId}'
  params: {
    name: replace(resourceGroup.value, '{env}', envName)
    location: location
    deploymentId: deploymentId
    tags: (enableResourceGroupTags) && contains(parameters[envKey].tags.resourceGroups, resourceGroup.key) ? parameters[envKey].tags.resourceGroups['${resourceGroup.key}'] : {}
    roleAssignments: [for roleAssignment in (enableResourceGroupRoleAssignments && contains(parameters[envKey].roleAssignments.resourceGroups, resourceGroup.key)) ? items(parameters[envKey].roleAssignments.resourceGroups['${resourceGroup.key}']) : []: { 
      principalId: sharedParameters.azureActiveDirectory[roleAssignment.key].objectId
      principalType: sharedParameters.azureActiveDirectory[roleAssignment.key].principalType
      role: roleAssignment.value
     }]
    //Not supported on Sponsorship subscriptions
    budgetAlerts: (enableResourceGroupBudgetAlerts && contains(parameters[envKey].budgetAlerts.resourceGroups, resourceGroup.key)) ? [
      {
        name: replace(replace(sharedParameters.naming.budgetAlert, '{purpose}', 'rg-${resourceGroup.key}'), '{env}', envName)
        budget: parameters[envKey].budgetAlerts.resourceGroups['${resourceGroup.key}']
        emailAddresses: parameters[envKey].budgetAlerts.emailAddresses
      }
    ] : []
  }
}]

//Not supported on Sponsorship subscriptions
//Describe buget alert on subscription level
module subscriptionBudgetAlert '../modules/budget-alert-subscription.bicep' = if(enableSubscriptionBudgetAlert) {
  scope: subscription(sharedParameters.subscriptions[envKey])
  name: 'sub-ba-${take(subscriptionBudgetAlertName,43)}-${deploymentId}'
  params: {
    name: subscriptionBudgetAlertName
    budget: parameters[envKey].budgetAlerts.subscription
    emailAddresses: parameters[envKey].budgetAlerts.emailAddresses  
  }
}

//Describe subscription tags
module subscriptionTags '../modules/tags-subscription.bicep' = if(enableSubscriptionTags) {
  name: 'sub-tags-${deploymentId}'
  params: {
    tags: parameters[envKey].tags.subscription
  }
}

//Describe subscription role assignments
module subscriptionRoleAssignments '../modules/role-assignment-subscription.bicep' = [for roleAssignment in items(parameters[envKey].roleAssignments.subscription) : {
  name: 'sub-ra-${take(guid(roleAssignment.value, roleAssignment.key),43)}-${deploymentId}'
  params: {
    principalId: sharedParameters.azureActiveDirectory[roleAssignment.key].objectId
    principalType: sharedParameters.azureActiveDirectory[roleAssignment.key].principalType
    roleName: roleAssignment.value
  }
}]
