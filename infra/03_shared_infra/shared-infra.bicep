//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get parameters
var parameters = loadJsonContent('./shared-infra-parameters.json')
var sharedParameters = loadJsonContent('../infra-parameters.json')
var deploymentScriptNameWithPurposePlaceholder = replace(sharedParameters.naming.deploymentScript, '{env}', envName)
var deploymentScriptIdentityName = replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', sharedParameters.sharedResources.deploymentScripts.purpose), '{env}', envName)
var deploymentScriptsStorageAccountName = replace(replace(sharedParameters.naming.storageAccount, '{purpose}', '${replace(sharedParameters.sharedResources.deploymentScripts.purpose, '-', '')}'), '{env}', envName)
var deploymentScriptsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.deploymentScripts.resourceGroup], '{env}', envName)
var logAnalyticsWorkspaceName = replace(replace(sharedParameters.naming.logAnalytics, '{purpose}', sharedParameters.sharedResources.logAnalytics.purpose), '{env}', envName)
var logAnalyticsResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.logAnalytics.resourceGroup], '{env}', envName)
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)
var apimApplicationInsightsName = replace(replace(sharedParameters.naming.applicationInsights, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apimKeyVaultName = replace(replace(sharedParameters.naming.keyVault, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apimIdentityName = replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apimPublicIpAddressName = replace(replace(sharedParameters.naming.publicIpAddress, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apimBackupStorageAccountName = replace(replace(sharedParameters.naming.storageAccount, '{purpose}', '${replace(sharedParameters.sharedResources.apiManagement.purpose, '-', '')}backup'), '{env}', envName)
var apimBackupLogicAppName = replace(replace(sharedParameters.naming.logicApp, '{purpose}', '${sharedParameters.sharedResources.apiManagement.purpose}-backup'), '{env}', envName)
var apimApplicationInsightsInstrumentationKeySecretName = 'apim-global-appinsights-instrumentationkey'
var apimApplicationInsightsInstrumentationNamedValueName = 'apim-global-appinsights-instrumentationkey'
var apimGlobalLoggerName = 'apim-global-logger'
var apimBackupContainerName = 'apim-backup'
var containerAppsEnvironmentName = replace(replace(sharedParameters.naming.containerAppsEnvironment, '{purpose}', sharedParameters.sharedResources.containerAppsEnvironment.purpose), '{env}', envName)
var containerAppsEnvironmentResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.containerAppsEnvironment.resourceGroup], '{env}', envName)
var allowPublicAccess = sharedParameters.networking[envKey].allowPublicAccess
var enablePrivateAccess = sharedParameters.networking[envKey].enablePrivateAccess
var allowAzureServices = sharedParameters.networking[envKey].allowAzureServices

//Set variables
var location = sharedParameters.regions.primary.location

//Describe Deployment Script identity
module deploymentScriptIdentity '../modules/user-assigned-identity.bicep' = {
  scope: az.resourceGroup(deploymentScriptsResourceGroupName)
  name: 'id-${take(deploymentScriptIdentityName, 47)}-${deploymentId}'
  params: {
    name: deploymentScriptIdentityName
    location: location
  }
}

//Describe Deployment Script storage account
module deploymentScriptStorageAccount '../modules/storage-account.bicep' = {
  scope: az.resourceGroup(deploymentScriptsResourceGroupName)
  name: 'st-${take(deploymentScriptsStorageAccountName, 47)}-${deploymentId}'
  params: {
    name: deploymentScriptsStorageAccountName
    sku: 'Standard_LRS'
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    enforceAzureAdAuth: false
    location: location
    deploymentId: deploymentId
  }
}

//Describe Log Analytics Workspace
module logAnalyticsWorkspace '../modules/log-analytics-workspace.bicep' = {
  scope: az.resourceGroup(logAnalyticsResourceGroupName)
  name: 'la-${take(logAnalyticsWorkspaceName, 47)}-${deploymentId}'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
  }
}

//Describe API Management landing zone
module apiManagementLandingZone '../landing_zones/api-management.bicep' = {
  name: 'apim-zone-${take(apiManagementName, 40)}-${deploymentId}'
  params: {
    name: apiManagementName
    resourceGroupName: apiManagementResourceGroupName
    sku: parameters.dev.apiManagement.sku
    location: location
    publisherEmail: parameters[envKey].apiManagement.publisherEmail
    publisherName: parameters[envKey].apiManagement.publisherName
    identityName: apimIdentityName
    networking_allowAzureServices: allowAzureServices
    networking_allowPublicAccess: allowPublicAccess
    networking_enablePrivateAccess: enablePrivateAccess
    networking_publicIpAddressName: apimPublicIpAddressName
    keyVault_name: apimKeyVaultName
    keyVault_sku: parameters[envKey].apiManagement.keyVaultSku
    keyVault_enableSoftDelete: parameters[envKey].apiManagement.keyVaultEnableSoftDelete
    applicationInsights_name: apimApplicationInsightsName
    applicationInsights_logAnalyticsId: logAnalyticsWorkspace.outputs.id
    applicationInsights_globalLoggerName: apimGlobalLoggerName
    applicationInsights_instrumentationKeyNamedValueName: apimApplicationInsightsInstrumentationNamedValueName
    applicationInsights_instrumentationKeySecretName: apimApplicationInsightsInstrumentationKeySecretName
    applicationInsights_logHttpBodies: parameters[envKey].apiManagement.logHttpBodies
    applicationInsights_verbosity: parameters[envKey].apiManagement.logVerbosity
    backup_logicAppName: apimBackupLogicAppName
    backup_storageAccountName: apimBackupStorageAccountName
    backup_storageAccountSku: parameters[envKey].apiManagement.backupStorageAccountSku
    backup_containerName: apimBackupContainerName
    deploymentScripts_nameWithPurposePlaceholder: deploymentScriptNameWithPurposePlaceholder
    deploymentScripts_identityName: deploymentScriptIdentityName
    deploymentScripts_storageAccountName: deploymentScriptsStorageAccountName
    deploymentScripts_resourceGroupName: deploymentScriptsResourceGroupName
    deploymentId: deploymentId
  }
}

//Describe Container Apps Environment
module containerAppsEnvironment '../modules/container-apps-environment.bicep' = {
  scope: az.resourceGroup(containerAppsEnvironmentResourceGroupName)
  name: 'cae-${take(containerAppsEnvironmentName, 46)}-${deploymentId}'
  params: {
    name: containerAppsEnvironmentName
    location: location
    enablePrivateAccess: enablePrivateAccess
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
  }
}
