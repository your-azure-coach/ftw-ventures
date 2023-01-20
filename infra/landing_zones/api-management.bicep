// Scope
targetScope = 'subscription'

// Parameters
param name string
@allowed([
  'Developer'
  'Standard'
  'Premium'
])
param sku string
param resourceGroupName string
param location string
param publisherEmail string
param publisherName string
param deploymentId string

param networking_allowPublicAccess bool
param networking_enablePrivateAccess bool
param networking_allowAzureServices bool
param networking_subnetId string = ''
param networking_publicIpAddressName string

param applicationInsights_name string
param applicationInsights_globalLoggerName string
param applicationInsights_logAnalyticsId string
param applicationInsights_instrumentationKeySecretName string
param applicationInsights_instrumentationKeyNamedValueName string
param applicationInsights_logHttpBodies bool
@allowed([ 'error', 'information', 'verbose', 'debug' ])
param applicationInsights_verbosity string

param keyVault_name string
@allowed([
  'standard'
  'premium'
])
param keyVault_sku string
param keyVault_enableSoftDelete bool

param backup_logicAppName string
param backup_storageAccountName string
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param backup_storageAccountSku string
param backup_containerName string

param deploymentScripts_identityName string
param deploymentScripts_resourceGroupName string


//Reference existing resources
resource apimResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
}

//Describe Azure API Management
module apiManagement '../modules/api-management.bicep' = {
  scope: apimResourceGroup
  name: 'apim-${take(name, 45)}-${deploymentId}'
  params: {
    name: name
    sku: sku
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    subnetId: networking_subnetId
    publicIpAddressName: networking_publicIpAddressName
    publisherEmail: publisherEmail
    publisherName: publisherName
    location: location
  }
}

//Describe Key Vault
module apimKeyVault '../modules/key-vault.bicep' = {
  scope: apimResourceGroup
  name: 'kv-${take(keyVault_name, 47)}-${deploymentId}'
  params: {
    name: keyVault_name
    location: location
    sku: keyVault_sku
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    allowAzureServices: networking_allowAzureServices
    enableSoftDelete: keyVault_enableSoftDelete
    deploymentId: deploymentId
  }
}

//Describe APIM role assignment on Key Vault
module apimKeyVaultRoleAssignment '../modules/role-assignment-key-vault.bicep' = {
  scope: apimResourceGroup
  name: 'ra-${take(name, 24)}-${deploymentId}'
  params: {
    roleName: 'Key Vault Secrets User'
    principalId: apiManagement.outputs.principalId
    principalType: 'ServicePrincipal'
    keyVaultName: apimKeyVault.outputs.name
  }
}

//Describe Application Insights
module apimApplicationInsights '../modules/application-insights.bicep' = {
  scope: apimResourceGroup
  name: 'appi-${take(applicationInsights_name, 45)}-${deploymentId}'
  params: {
    name: applicationInsights_name
    location: location
    logAnalyticsWorkspaceId: applicationInsights_logAnalyticsId
    kind: 'web'
    deploymentId: deploymentId
    keyVaultName: apimKeyVault.outputs.name
    storeInstrumentationKeyInKeyVault: true
    appInsightsInstrumentationKeySecretName: applicationInsights_instrumentationKeySecretName
  }
}

//Describe Application Insights global logger for API Management
module apimGlobalLogger '../modules/api-management-app-insights-global-logger.bicep' = {
  scope: apimResourceGroup
  name: 'apim-global-logger-${deploymentId}'
  params: {
    apimName: apiManagement.outputs.name
    applicationInsightsId: apimApplicationInsights.outputs.id
    instrumentationKeyNamedValueName: applicationInsights_instrumentationKeyNamedValueName
    instrumentationKeySecretUri: apimApplicationInsights.outputs.instrumentationKeySecretUri
    loggerName: applicationInsights_globalLoggerName
    logHttpBodies: applicationInsights_logHttpBodies
    verbosity: applicationInsights_verbosity
  }
  dependsOn: [ apimApplicationInsights ]
}

//Describe Log Analytics global diagnostics for API Management
module apimGlobalLogAnalyticsDiagnostics '../modules/api-management-log-analytics-diagnostics.bicep' = {
  scope: apimResourceGroup
  name: 'apim-global-log-analytics-diagnostics-${deploymentId}'
  params: {
    apimName: apiManagement.outputs.name
    logAnalyticsWorkspaceId: applicationInsights_logAnalyticsId
  }
}

//Describe storage account for backup
module apimBackupStorageAccount '../modules/storage-account.bicep' = {
  scope: apimResourceGroup
  name: 'sa-${take(backup_storageAccountName , 47)}-${deploymentId}'
  params: {
    name: backup_storageAccountName
    sku: backup_storageAccountSku
    enablePrivateAccess: networking_enablePrivateAccess
    allowPublicAccess: networking_allowPublicAccess
    location: location
    deploymentId: deploymentId
    blobContainers: [{name: backup_containerName}]
  }
}

//Describe API Management backup
module apimBackup '../modules/api-management-backup.bicep' = {
  scope: apimResourceGroup
  name: 'apim-backup-${take(name , 38)}-${deploymentId}'
  params: {
    apimName: apiManagement.outputs.name
    blobContainerName: backup_containerName
    logicAppName: backup_logicAppName
    storageAccountName: apimBackupStorageAccount.outputs.name
    location: location
    deploymentId: deploymentId
  }
}

//Reference Deployment Script Identity
resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: deploymentScripts_identityName
  scope: az.resourceGroup(deploymentScripts_resourceGroupName)
}

//Grant Deployment Script Identity access to remove API Management defaults
module defaultsApimRoleAssignment '../modules/role-assignment-api-management.bicep' = {
  scope: apimResourceGroup
  name: 'ra-apim-${take(name, 42)}-${deploymentId}'
  params: {
    roleName:  'API Management Service Contributor'
    principalId: deploymentScriptIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    apiManagementName: apiManagement.outputs.name
  }
}

//Remove API Management defaults
module removeApimDefaults '../modules/api-management-remove-defaults.bicep' = {
  scope: apimResourceGroup
  name: 'apim-defaults-${take(name , 36)}-${deploymentId}'
  params: {
    scriptResourceGroupName: deploymentScripts_resourceGroupName
    apimName: apiManagement.outputs.name
    apimResourceGroupName: apimResourceGroup.name
    scriptIdentityId: deploymentScriptIdentity.id
    deploymentId: deploymentId
    location: location
  }
  dependsOn: [ defaultsApimRoleAssignment ]
}
