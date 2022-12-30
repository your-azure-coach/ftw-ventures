// Scope
targetScope = 'resourceGroup'

// Parameters
param scriptIdentityId string
param scriptResourceGroupName string
param location string
param apimName string 
param apimResourceGroupName string
param deploymentId string

// Call script
module removeApiManagementDefault 'deployment-script.bicep' = {
  name: 'remove-apim-defaults-${take(apimName, 29)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: 'deploy-remove-apim-defaults-${guid(apimName, deploymentId)}'
    location: location
    deploymentIdentityId: scriptIdentityId
    scriptContent: loadTextContent('scripts/api-management-remove-defaults.ps1')
    scriptArguments: '-ApiManagementName ${apimName} -ResourceGroupName ${apimResourceGroupName}'
    deploymentId: deploymentId
  }
}
