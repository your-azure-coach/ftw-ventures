// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param scriptVariables object = {}
param scriptContent string
param azureCliVersion string = '2.42.0'
param deploymentIdentityId string
param deploymentContainerInstanceName string
param deploymentStorageAccountName string
param deploymentId string

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: name
  location: location
  kind:  'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentIdentityId}': {}
    }
  }
  properties: {
    forceUpdateTag: '${name}-${deploymentId}'
    azCliVersion: azureCliVersion
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [for variable in items(scriptVariables):  {
        name: variable.key
        value: variable.value
      }]
    scriptContent: scriptContent
    cleanupPreference: 'Always'
    containerSettings: {
      containerGroupName: deploymentContainerInstanceName
    }
    storageAccountSettings: {
      storageAccountName: deploymentStorageAccountName
      storageAccountKey: listKeys(resourceId('Microsoft.Storage/storageAccounts', deploymentStorageAccountName), '2019-06-01').keys[0].value
    }
  }
}

output result object = deploymentScript.properties.outputs.result
