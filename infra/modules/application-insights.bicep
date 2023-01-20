// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
@allowed([ 'web', 'other'])
param kind string
param logAnalyticsWorkspaceId string
param location string
param appInsightsConnectionStringSecretName string = 'APPINSIGHTS--CONNECTIONSTRING'
param appInsightsInstrumentationKeySecretName string = 'APPINSIGHTS--INSTRUMENTATIONKEY'
param storeInstrumentationKeyInKeyVault bool = false
param keyVaultName string = ''
param deploymentId string


// Describe Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: kind
  properties: {
    Application_Type:  kind
    WorkspaceResourceId: logAnalyticsWorkspaceId 
  }
}

// Add connection string to Key Vault
module appInsightsConnectionStringKeyVault '../modules/key-vault-secret.bicep' = if (keyVaultName != '') {
  name: 'ks-${take(guid(keyVaultName, applicationInsights.id, appInsightsConnectionStringSecretName), 24)}-${deploymentId}'
  params: {
    name: appInsightsConnectionStringSecretName
    value: applicationInsights.properties.ConnectionString
    keyVaultName: keyVaultName
  }
}

// Add instrumentation key to Key Vault
module appInsightsInstrumentationKeyKeyVault '../modules/key-vault-secret.bicep' = if (keyVaultName != '' && storeInstrumentationKeyInKeyVault) {
  name: 'ks-${take(guid(keyVaultName, applicationInsights.id, appInsightsInstrumentationKeySecretName), 24)}-${deploymentId}'
  params: {
    name: appInsightsInstrumentationKeySecretName
    value: applicationInsights.properties.InstrumentationKey
    keyVaultName: keyVaultName
  }
}

output id string = applicationInsights.id
output name string = name
output connectionStringSecretName string = (keyVaultName != '') ? appInsightsConnectionStringSecretName : ''
output connectionStringSecretUri string = (keyVaultName != '') ? appInsightsConnectionStringKeyVault.outputs.uri : ''
output connectionStringSecretVersionedUri string = (keyVaultName != '') ? appInsightsConnectionStringKeyVault.outputs.versionedUri : ''
output instrumentationKeySecretName string = (keyVaultName != '') ? appInsightsInstrumentationKeySecretName : ''
output instrumentationKeySecretUri string = (keyVaultName != '' && storeInstrumentationKeyInKeyVault) ? appInsightsInstrumentationKeyKeyVault.outputs.uri : ''
output instrumentationKeySecretVerionsedUri string = (keyVaultName != '' && storeInstrumentationKeyInKeyVault) ? appInsightsInstrumentationKeyKeyVault.outputs.versionedUri : ''
