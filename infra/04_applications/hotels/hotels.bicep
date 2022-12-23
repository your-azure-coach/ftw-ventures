//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get parameters
var parameters = loadJsonContent('./hotels-parameters.json')
var sharedParameters = loadJsonContent('../../infra-parameters.json')

//Set variables
var location = sharedParameters.regions.primary.location
var resourceGroupName = replace(sharedParameters.resourceGroups['app-hotels'], '{env}', envName)
var identityName = replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', 'app-hotels'), '{env}', envName)
var containerAppsEnvironmentName = replace(replace(sharedParameters.naming.containerAppsEnvironment, '{purpose}', sharedParameters.sharedResources.containerAppsEnvironment.purpose), '{env}', envName)
var containerAppsEnvironmentResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.containerAppsEnvironment.resourceGroup], '{env}', envName)
var containerRegistryName = replace(replace(sharedParameters.naming.containerRegistry, '{purpose}', 'apphotels'), '{env}', envName)
var containerAppName = replace(replace(sharedParameters.naming.containerApp, '{purpose}', 'app-hotels-graph-api'), '{env}', envName)
var allowPublicAccess = sharedParameters.networking[envKey].allowPublicAccess
var enablePrivateAccess = sharedParameters.networking[envKey].enablePrivateAccess
var allowAzureServices = sharedParameters.networking[envKey].allowAzureServices
var deploymentScriptNameWithPurposePlaceholder = replace(sharedParameters.naming.deploymentScript, '{env}', envName)
var deploymentScriptsStorageAccountName = replace(replace(sharedParameters.naming.storageAccount, '{purpose}', '${replace(sharedParameters.sharedResources.deploymentScripts.purpose, '-', '')}'), '{env}', envName)
var deploymentScriptsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.deploymentScripts.resourceGroup], '{env}', envName)
var deploymentScriptsContainerInstanceName = replace(replace(sharedParameters.naming.containerInstance, '{purpose}', sharedParameters.sharedResources.deploymentScripts.purpose), '{env}', envName)


//Reference existing resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvironmentName
  scope: az.resourceGroup(containerAppsEnvironmentResourceGroupName)
}

//Describe user assigned managed identity
module identity '../../modules/user-assigned-identity.bicep' = {
  scope: resourceGroup
  name: 'id-${take(identityName, 47)}-${deploymentId}'
  params: {
    name: identityName
    location: location
  }
}

//Describe Container Registry
module containerRegistry '../../modules/container-registry.bicep' = {
  scope: resourceGroup
  name: 'acr-${take(containerRegistryName, 46)}-${deploymentId}'
  params: {
    name: containerRegistryName
    sku: parameters[envKey].containerRegistrySku
    allowAzureServices: allowAzureServices 
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    location: location
    deploymentId: deploymentId
  }
}

//Grant identity access rights to Pull Container Images
module containerRegistryRoleAssignment '../../modules/role-assignment-container-registry.bicep' = {
  scope: resourceGroup
  name: 'ra-${take(containerRegistryName, 47)}-${deploymentId}'
  params: {
    containerRegistryName: containerRegistry.outputs.name
    principalId: identity.outputs.principalId
    principalType: 'ServicePrincipal'
    roleName: 'AcrPull'
  }
}

//Describe Container App
module containerAppInfra '../../modules/container-app-infra.bicep' = {
  scope: resourceGroup
  name: 'ca-${take(containerAppName, 47)}-${deploymentId}'
  params: {
    name: containerAppName
    location: location
    allowPublicAccess: allowPublicAccess
    containerRegistryServer: containerRegistry.outputs.serverName
    environmentId: containerAppsEnvironment.id
    requiresHttpsIngress: true
    revisionMode: 'Single'
    userAssignedIdentityId: identity.outputs.id
    userAssignedIdentityPrincipalId: identity.outputs.principalId
    deploymentId: deploymentId
    scriptContainerInstanceName: deploymentScriptsContainerInstanceName
    scriptNameWithPurposePlaceholder: deploymentScriptNameWithPurposePlaceholder
    scriptStorageAccountName: deploymentScriptsStorageAccountName
    scriptResourceGroupName: deploymentScriptsResourceGroupName
  }
}
