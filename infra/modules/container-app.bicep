// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param environmentId string
param containerRegistryName string
@allowed([ 'Single', 'Multiple' ])
param revisionMode string
param allowPublicAccess bool
param ingressTargetPort int = 80
param scriptIndentityId string
param scriptResourceGroupName string
param deploymentId string


module containerApp 'deployment-script.bicep' = {
  name: 'ca-posh-${take(name, 44)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: 'deploy-container-app-${guid(name, environmentId, deploymentId)}'
    scriptArguments: '-ContainerAppName ${name} -ResourceGroupName ${az.resourceGroup().name} -Location ${location} -EnvironmentId ${environmentId} -ContainerRegistryName ${containerRegistryName} -RevisionMode ${revisionMode} -AllowPublicAccess ${allowPublicAccess} -IngressTargetPort ${ingressTargetPort}'
    scriptContent: loadTextContent('scripts/container-apps-upsert.ps1')
    location: location
    deploymentIdentityId: scriptIndentityId
    deploymentId: deploymentId
  }
}


output name string = name
output principalId string = containerApp.outputs.result.principalId
output principalAppId string = containerApp.outputs.result.principalAppId
