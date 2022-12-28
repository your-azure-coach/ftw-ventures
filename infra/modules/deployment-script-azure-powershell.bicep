// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param scriptContent string
param scriptArguments string
param azurePowerShellVersion string = '8.0'
param deploymentIdentityId string
param deploymentStorageAccountName string
param deploymentId string

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: name
  location: location
  kind:  'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentIdentityId}': {}
    }
  }
  properties: {
    forceUpdateTag: '${name}-${deploymentId}'
    azPowerShellVersion: azurePowerShellVersion
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    arguments: scriptArguments
    scriptContent: scriptContent
    cleanupPreference: 'Always'
    storageAccountSettings: {
      storageAccountName: deploymentStorageAccountName
      storageAccountKey: listKeys(resourceId('Microsoft.Storage/storageAccounts', deploymentStorageAccountName), '2019-06-01').keys[0].value
    }
  }
}

//output result object = deploymentScript.properties.outputs.result
