// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param environmentId string
param userAssignedIdentityId string
param userAssignedIdentityPrincipalId string
param containerRegistryServer string
param requiresHttpsIngress bool
@allowed([ 'Single', 'Multiple' ])
param revisionMode string
param allowPublicAccess bool
param scriptNameWithPurposePlaceholder string
param scriptIndentityId string
param scriptStorageAccountName string
param scriptResourceGroupName string
param deploymentId string


//Grant the identity rights to query existing container apps
module roleAssignmentToQueryContainerApps 'role-assignment-resource-group.bicep' = {
  name: 'ra-${take(guid(userAssignedIdentityPrincipalId, name, 'Reader'), 37)}-${deploymentId}'
  params: {
    principalId: userAssignedIdentityPrincipalId
    principalType: 'ServicePrincipal'
    roleName: 'Reader'
  }
}

var defaultContainerAppTemplate = {
  containers: [
    {
      name: 'container-app-main-image'
      image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
    }
  ]
  scale: {
    minReplicas: 0
    maxReplicas: 10
  }
}

//Get the existing configuration of the container app
module getContainerAppProperties 'container-apps-get-properties.bicep' = {
  name: 'get-capp-properties-${take(name, 29)}-${deploymentId}'
  params: {
    containerAppName: name
    containerAppResourceGroupName: resourceGroup().name
    deploymentId: deploymentId
    location: location
    scriptIdentityId: scriptIndentityId
    scriptNameWithPurposePlaceholder: scriptNameWithPurposePlaceholder
    scriptStorageAccountName: scriptStorageAccountName
    scriptResourceGroupName: scriptResourceGroupName
  }
  dependsOn: [roleAssignmentToQueryContainerApps]
}

//Deploy container app with new infrastructure and the existing application template (or default template for new)
//Call an explicit module instead of resource because of issues with a dynamic template:https://github.com/microsoft/azure-container-apps/issues/391#issuecomment-1299607076
module containerApp 'container-app.bicep' = { 
  name: 'cam-${take(name, 46)}-${deploymentId}'
  params: {
    name: name
    location: location
    environmentId: environmentId
    userAssignedIdentityId: userAssignedIdentityId
    requiresHttpsIngress: requiresHttpsIngress
    allowPublicAccess: allowPublicAccess
    revisionMode: revisionMode
    containerRegistryServer: containerRegistryServer
    containerAppTemplate: contains(getContainerAppProperties.outputs.properties, 'template') ? getContainerAppProperties.outputs.properties.template : defaultContainerAppTemplate 
  }
}
