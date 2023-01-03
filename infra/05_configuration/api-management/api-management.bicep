//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../infra-parameters.json')
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Describe Global API Management policy
module globalPolicy '../../modules/api-management-policy.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-global-policy-${deploymentId}'
  params: {
    apimName: apiManagementName
    policyScope: 'global'
    policyXml: loadTextContent('policies/global.xml')
  }
}
