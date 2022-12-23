// Scope
targetScope = 'resourceGroup'

// Parameters
param applicationInsightsName string
param applicationInsightsResourceGroupName string
param keyVaultName string
param keyVaultResourceGroupName string
param secretName string
param deploymentId string


// Reference existing resources
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
  scope: resourceGroup(applicationInsightsResourceGroupName)
}

// Create secret
module instrumentationKeySecret 'key-vault-secret.bicep' = {
  name: 'kv-se-${take(secretName, 44)}-${deploymentId}'
  scope: resourceGroup(keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    name: secretName
    value: applicationInsights.properties.InstrumentationKey
  }
}

output instrumentationKeySecretUri string = instrumentationKeySecret.outputs.uri
output instrumentationKeySecretVersionedUri string = instrumentationKeySecret.outputs.versionedUri
