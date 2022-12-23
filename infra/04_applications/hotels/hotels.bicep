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
var logAnalyticsWorkspaceName = replace(replace(sharedParameters.naming.logAnalytics, '{purpose}', sharedParameters.sharedResources.logAnalytics.purpose), '{env}', envName)
var logAnalyticsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.logAnalytics.resourceGroup], '{env}', envName)
var containerAppsEnvironmentName = replace(replace(sharedParameters.naming.containerAppsEnvironment, '{purpose}', sharedParameters.sharedResources.containerAppsEnvironment.purpose), '{env}', envName)
var containerAppsEnvironmentResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.containerAppsEnvironment.resourceGroup], '{env}', envName)
var containerRegistryName = replace(replace(sharedParameters.naming.containerRegistry, '{purpose}', 'apphotels'), '{env}', envName)
var containerAppName = replace(replace(sharedParameters.naming.containerApp, '{purpose}', 'hotel-supergraph'), '{env}', envName)
var appConfigurationName = replace(replace(sharedParameters.naming.appConfiguration, '{purpose}', 'app-hotels'), '{env}', envName)
var keyVaultName = replace(replace(sharedParameters.naming.keyVault, '{purpose}', 'app-hotels'), '{env}', envName)
var redisCacheName = replace(replace(sharedParameters.naming.redisCache, '{purpose}', 'app-hotels'), '{env}', envName)
var sqlServerName = replace(replace(sharedParameters.naming.sqlServer, '{purpose}', 'app-hotels'), '{env}', envName)
var sqlDatabaseName = replace(replace(sharedParameters.naming.sqlDatabase, '{purpose}', 'app-hotels'), '{env}', envName)
var applicationInsightsName = replace(replace(sharedParameters.naming.applicationInsights, '{purpose}', 'app-hotels'), '{env}', envName)
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
  scope: az.resourceGroup(logAnalyticsResourceGroupName)
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

//Describe Application Insights
module applicationInsights '../../modules/application-insights.bicep' = {
  scope: resourceGroup
  name: 'appi-${take(applicationInsightsName, 45)}-${deploymentId}'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.id
    kind:  'web'
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

//Describe App Configuration
module appConfiguration '../../modules/app-configuration.bicep' = {
  scope: resourceGroup
  name: 'aco-${take(appConfigurationName, 46)}-${deploymentId}'
  params: {
    name: appConfigurationName
    location: location
    sku: 'standard'
    userAssignedIdentityId: identity.outputs.id
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess 
    deploymentId: deploymentId    
  }
}

//Describe Key Vault
module keyVault '../../modules/key-vault.bicep' = {
  scope: resourceGroup
  name: 'kv-${take(keyVaultName, 47)}-${deploymentId}'
  params: {
    name: keyVaultName
    location: location
    sku: parameters[envKey].keyVaultSku
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    allowAzureServices: allowAzureServices
    enableSoftDelete: parameters[envKey].keyVaultEnableSoftDelete
    deploymentId: deploymentId
  }
}

//Describe Redis Cache
module redisCache '../../modules/redis-cache.bicep' = {
  scope: resourceGroup
  name: 'rc-${take(redisCacheName, 47)}-${deploymentId}'
  params: {
    name: redisCacheName
    sku: parameters[envKey].redisSku
    location: location
    userAssignedIdentityId: identity.outputs.id
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    keyVaultName: keyVault.outputs.name 
    deploymentId: deploymentId
  }
}

//Describe SQL Server
module sqlServer '../../modules/sql-server.bicep' = {
  scope: resourceGroup
  name: 'sqls-${take(sqlServerName, 45)}-${deploymentId}'
  params: {
    name: sqlServerName
    location: location
    userAssignedIdentityId: identity.outputs.id
    allowAzureServices: allowAzureServices
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    sqlAdminGoupObjectId: sharedParameters.azureActiveDirectory[parameters[envKey].sqlAdminGroupAlias].objectId
    sqlAdminGroupName: sharedParameters.azureActiveDirectory[parameters[envKey].sqlAdminGroupAlias].name
    keyVaultName: keyVault.outputs.name   
    deploymentId: deploymentId
  }
}

//Describe SQL Database
module sqlDatabase '../../modules/sql-database.bicep' = {
  scope: resourceGroup
  name: 'sqldb-${take(sqlDatabaseName, 44)}-${deploymentId}'
  params: {
    name: sqlDatabaseName
    serverName: sqlServer.outputs.name
    location: location
    sku: parameters[envKey].sqlDatabaseSku    
  }
}
