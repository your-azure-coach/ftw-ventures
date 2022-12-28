// Scope
targetScope = 'resourceGroup'

// Parameters
param scriptNameWithPurposePlaceholder string
param scriptIdentityId string
param scriptStorageAccountName string
param scriptResourceGroupName string
param location string
param containerAppName string 
param containerAppResourceGroupName string
param deploymentId string

// Call script
module getContainerAppProperties 'deployment-script-azure-cli.bicep' = {
  name: 'ca-template-${take(containerAppName, 38)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: replace(scriptNameWithPurposePlaceholder, '{purpose}', 'capp-template-${containerAppName}')
    location: location
    deploymentIdentityId: scriptIdentityId
    deploymentStorageAccountName: scriptStorageAccountName
    scriptContent: loadTextContent('scripts/container-apps-get-properties.sh')
    deploymentId: deploymentId
    scriptVariables: {
      'CONTAINER_APP_NAME': containerAppName
      'RESOURCE_GROUP_NAME': containerAppResourceGroupName
    }
  }
}

output properties object = getContainerAppProperties.outputs.result.properties
