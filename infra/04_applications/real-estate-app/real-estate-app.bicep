//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get parameters
var parameters = loadJsonContent('./real-estate-app-parameters.json')
var sharedParameters = loadJsonContent('../../infra-parameters.json')
var location = sharedParameters.regions.primary.location
var allowAzureServices = sharedParameters.networking[envKey].allowAzureServices
var allowPublicAccess = sharedParameters.networking[envKey].allowPublicAccess
var enablePrivateAccess = sharedParameters.networking[envKey].enablePrivateAccess
var purpose = 'real-estate'

//Get infra names
module naming '../../infra-naming.bicep' = {
  name: 'infra-names-${deploymentId}'
  params: {
    envName: envName
    purpose: purpose
  }
}

//Get shared infra
module shared '../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: replace(sharedParameters.resourceGroups[purpose], '{env}', envName)
}

//Describe App Service Plan
module appServicePlan '../../modules/app-service-plan.bicep' = {
  scope: resourceGroup
  name: 'plan-${envName}-${purpose}-${deploymentId}'
  params: {
    name: naming.outputs.appServicePlanName
    sku: parameters[envKey].appServicePlanSku
    location: location
  }
}

//Describe Key Vault
module keyVault '../../modules/key-vault.bicep' = {
  scope: resourceGroup
  name: 'kv-${envName}-${purpose}-${deploymentId}'
  params: {
    name: naming.outputs.keyVaultName
    sku: parameters[envKey].keyVaultSku
    enableSoftDelete: parameters[envKey].keyVaultEnableSoftDelete
    enablePrivateAccess: enablePrivateAccess
    allowAzureServices: allowAzureServices
    allowPublicAccess: allowPublicAccess
    location: location
    deploymentId: deploymentId
  }
}

//Describe Application Insights
module applicationInsights '../../modules/application-insights.bicep' = {
  scope: resourceGroup
  name: 'appi-${envName}-${purpose}-${deploymentId}'
  params: {
    name: naming.outputs.applicationInsightsName
    kind: 'web'
    logAnalyticsWorkspaceId: shared.outputs.logAnalyticsId
    keyVaultName: keyVault.outputs.name
    location: location
    deploymentId: deploymentId
  }
}

//Describe Web Apps
var webAppNames = [ 'sales', 'rental' ]

module appServices '../../modules/app-service.bicep' = [for webAppName in webAppNames: {
  scope: resourceGroup
  name: 'app-${envName}-${webAppName}-${deploymentId}'
  params: {
    name: replace(naming.outputs.appServiceNameWithPlaceholder, '{purpose}', webAppName)
    appServicePlanId: appServicePlan.outputs.id
    appServicePlanSku: appServicePlan.outputs.sku
    appInsightsProfiler_enable: true
    appInsightsProfiler_keyVaultName: keyVault.outputs.name
    appInsightsProfiler_connectionStringSecretName: applicationInsights.outputs.connectionStringSecretName
    location: location
    deploymentId: deploymentId
  }
}]

//Describe Storage Account
module storageAccount '../../modules/storage-account.bicep' = {
  scope: resourceGroup
  name: 'st-${envName}-${purpose}-${deploymentId}'
  params: {
    name: naming.outputs.storageAccountName
    sku: parameters[envKey].storageAccountSku
    allowPublicAccess: allowPublicAccess
    enablePrivateAccess: enablePrivateAccess
    blobContainers: [
      'mocking'
    ]
    deploymentId: deploymentId
    location: location
  }
}

//Upload blob for mocking
module mockBlob '../../modules/storage-account-upload-blob.bicep' = { 
  scope: resourceGroup
  name: 'blob-${envName}-mocking-${deploymentId}'
  params: {
    storageAccountName: storageAccount.outputs.name
    blobContainerName: 'mocking'
    blobName: 'rental-apartments.json'
    blobBase64Content: loadFileAsBase64('resources/rental-houses.json')
    scriptIdentityId: shared.outputs.deploymentScriptsIdentityId
    scriptIdentityPrincipalId: shared.outputs.deploymentScriptsIdentityPrincipalId
    scriptResourceGroupName: shared.outputs.deploymentScriptsResourceGroupName
    deploymentId: deploymentId
    location: location
  }
}

//Grant API Management access on storage account to access mock files
module apimStoragePermission '../../modules/role-assignment-storage-account.bicep' = {
  scope: resourceGroup
  name: 'ra-apim-${envName}-mocking-${deploymentId}'
  params: {
    principalId: shared.outputs.apiManagementPrincipalId
    principalType: 'ServicePrincipal'
    roleName: 'Storage Blob Data Contributor'
    storageAccountName: storageAccount.outputs.name
  }
}
