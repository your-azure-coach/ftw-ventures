// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param appServicePlanId string
param appServicePlanSku string
param ipRestriction_enable bool
param ipRestriction_allowedIpAddresses array = []
param appInsightsProfiler_enable bool
param appInsightsProfiler_keyVaultName string = ''
param appInsightsProfiler_connectionStringSecretName string = ''
param appSettings object = { }
param deploymentId string

var applicationInsightsAppSettings = appInsightsProfiler_enable ? {
  'APPLICATIONINSIGHTS_CONNECTION_STRING' : '@Microsoft.KeyVault(VaultName=${appInsightsProfiler_keyVaultName};SecretName=${appInsightsProfiler_connectionStringSecretName})'
  'ApplicationInsightsAgent_EXTENSION_VERSION' : '~3'
  'APPINSIGHTS_PROFILERFEATURE_VERSION' : '1.0.0'
  'DiagnosticServices_EXTENSION_VERSION' : '~3'
  'InstrumentationEngine_EXTENSION_VERSION' : '~1'
  'XDT_MicrosoftApplicationInsights_BaseExtensions' : '~1'
  'APPINSIGHTS_JAVASCRIPT_ENABLED' : 'true'
} : {}

//Describe App Service
resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      alwaysOn: (appServicePlanSku == 'F1' || appServicePlanSku == 'D1' || appServicePlanSku == 'Y1') ? false : true
      httpLoggingEnabled: true
    }
  }
}

//Grant App Service permissions to read Key Vault secrets
module keyVaultRoleAssignment 'role-assignment-key-vault.bicep' = {
  name: 'kv-ra-${name}-${deploymentId}'
  params: {
    keyVaultName: appInsightsProfiler_keyVaultName
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
    roleName: 'Key Vault Secrets User'
  }
}

//Set application settings
//This workaround is needed to avoid that we remove app settings that are added by the application team
//More info here: https://github.com/Azure/azure-cli/issues/11718#issuecomment-910243046
module currentAppSettings 'app-service-current-settings.bicep' = {
  name: 'appset-${take(name, 45)}-${deploymentId}'
  params: {
    name: appService.name
  }
}

resource applicationSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${name}/appsettings'
  properties: union(currentAppSettings.outputs.appSettings, appSettings, applicationInsightsAppSettings)
}

//Set IP restrictions
var allowedIpAddresses = [for (ipAddress, i) in ipRestriction_allowedIpAddresses: {
  ipAddress: '${ipAddress}/32'
  action: 'Allow'
  priority: 800 + i
  name: 'Allowed IP Address #${i + 1}'
}]

var ipSecurityRestrictions = union(allowedIpAddresses, [{
  ipAddress: 'Any'
  action: ipRestriction_enable ? 'Deny' : 'Allow'
  priority: 2147483647
  name: ipRestriction_enable ? 'Deny all' : 'Allow all'
}])

resource siteConfig 'Microsoft.Web/sites/config@2020-12-01' = {
  name: 'web'
  parent: appService
  properties: {
    ipSecurityRestrictions: ipSecurityRestrictions
    ipSecurityRestrictionsDefaultAction: ipRestriction_enable ? 'Deny' : 'Allow'
  }
}
