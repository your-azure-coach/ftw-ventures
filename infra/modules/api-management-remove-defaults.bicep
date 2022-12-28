// Scope
targetScope = 'resourceGroup'

// Parameters
param scriptNameWithPurposePlaceholder string
param scriptIdentityId string
param scriptStorageAccountName string
param scriptResourceGroupName string
param location string
param apimName string 
param apimResourceGroupName string
param deploymentId string

// Call script
module removeApiManagementDefault 'deployment-script-azure-cli.bicep' = {
  name: 'remove-apim-defaults-${take(apimName, 29)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: replace(scriptNameWithPurposePlaceholder, '{purpose}', 'apim-defaults')
    location: location
    deploymentIdentityId: scriptIdentityId
    deploymentStorageAccountName: scriptStorageAccountName
    scriptContent: loadTextContent('scripts/api-management-remove-defaults.sh')
    deploymentId: deploymentId
    scriptVariables: {
      'API_MANAGEMENT_NAME': apimName
      'RESOURCE_GROUP_NAME': apimResourceGroupName
    }
  }
}
