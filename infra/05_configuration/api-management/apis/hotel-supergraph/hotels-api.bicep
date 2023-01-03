//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envName string
param definitionUrl string
param version string = 'v1'
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../../infra-parameters.json')
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Describe Hotels API
module hotelsApi '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-hotels-api-${deploymentId}'
  params: {
    apimName: apiManagementName
    displayName: 'Hotels API'
    id: 'hotels-api'
    path: 'hotels-api'
    requiresSubscription: true
    type: 'graphql'
    definitionUrl: definitionUrl
    version: version
  }
}
