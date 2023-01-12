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

//Describe Global API Management policy
module globalPolicy '../../../modules/api-management-policy.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-global-policy-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    policyScope: 'global'
    policyXml: loadTextContent('policy/global.xml')
  }
}
