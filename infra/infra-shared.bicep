//Define scope
targetScope = 'subscription'

//Define parameters
param envName string

//Get shared parameters
var sharedParameters = loadJsonContent('infra-parameters.json')

//Log Analytics
var logAnalyticsName = replace(replace(sharedParameters.naming.logAnalytics, '{purpose}', sharedParameters.sharedResources.logAnalytics.purpose), '{env}', envName)
var logAnalyticsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.logAnalytics.resourceGroup], '{env}', envName)

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName
  scope: az.resourceGroup(logAnalyticsResourceGroupName)
}

//API Management
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apiManagementName
  scope: az.resourceGroup(apiManagementResourceGroupName)
}

//Container Apps Environment
var containerAppsEnvironmentName = replace(replace(sharedParameters.naming.containerAppsEnvironment, '{purpose}', sharedParameters.sharedResources.containerAppsEnvironment.purpose), '{env}', envName)
var containerAppsEnvironmentResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.containerAppsEnvironment.resourceGroup], '{env}', envName)

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvironmentName
  scope: az.resourceGroup((containerAppsEnvironmentResourceGroupName))
}

//Deployment Scripts
var deploymentScriptsIdentityName = replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', sharedParameters.sharedResources.deploymentScripts.purpose), '{env}', envName)
var deploymentScriptsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.deploymentScripts.resourceGroup], '{env}', envName)

resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: deploymentScriptsIdentityName
  scope: az.resourceGroup(deploymentScriptsResourceGroupName)
}

//Return shared resources
output apiManagementName string = apiManagementName
output apiManagementResourceGroupName string = apiManagementResourceGroupName
output apiManagementId string = apiManagement.id
output apiManagementPrincipalId string = apiManagement.identity.principalId
output apiManagementStaticIpAddress string = (apiManagement.properties.publicIPAddresses != null) ? apiManagement.properties.publicIPAddresses[0] : apiManagement.properties.privateIPAddresses[0]
output containerAppsEnvironmentName string = containerAppsEnvironmentName
output containerAppsEnvironmentResourceGroupName string = containerAppsEnvironmentResourceGroupName
output containerAppsEnvironmentId string = containerAppsEnvironment.id
output deploymentScriptsIdentityName string = deploymentScriptsIdentityName
output deploymentScriptsResourceGroupName string = deploymentScriptsResourceGroupName
output deploymentScriptsIdentityId string = deploymentScriptIdentity.id
output deploymentScriptsIdentityPrincipalId string = deploymentScriptIdentity.properties.principalId
output deploymentScriptsIdentityClientId string = deploymentScriptIdentity.properties.clientId
output logAnalyticsName string = logAnalyticsName
output logAnalyticsResourceGroupName string = logAnalyticsResourceGroupName
output logAnalyticsId string = logAnalytics.id
