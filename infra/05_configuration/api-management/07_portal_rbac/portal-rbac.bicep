//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../infra-parameters.json')
var apimResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Get shared infra
module shared '../../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

//Describe Groups
module group '../../../modules/api-management-group-aad.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-group-global-developers-${deploymentId}'
  params: {
    name: sharedParameters.azureActiveDirectory.group_global_developers.name
    apimName: shared.outputs.apiManagementName 
    aadGroupObjectId:  sharedParameters.azureActiveDirectory.group_global_developers.objectId
  }
}

module product '../../../modules/api-management-product.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-product-global-developers-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName 
    name: 'internal-${toLower(sharedParameters.azureActiveDirectory.group_global_developers.name)}-product'
    apis: [
      'hotel-api-v1'
      'real-estate-api-v1'
    ]
    groups: [
      toLower(sharedParameters.azureActiveDirectory.group_global_developers.name)
    ]
  }
  dependsOn: [
    group
  ]
}
