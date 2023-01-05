//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param definitionUrl string
param version string = 'v1'
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../../infra-parameters.json')
var parameters = loadJsonContent('../../api-management-properties.json')
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-real-estate-rental-api-${deploymentId}'
  params: {
    apimName: apiManagementName
    displayName: 'Real Estate Rental API'
    id: 'real-estate-rental-api'
    path: 'real-estate-rental-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'graphql'
    protocols: [
      'https'
      'wss'
    ]
    definitionUrl: definitionUrl
    version: version
    tags: [ 'System' ]
  }
}

//Describe API Backend for local routing
module apiBackend '../../../../modules/api-management-backend.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-real-estate-rental-backend-${deploymentId}'
  params: {
    apimName: apiManagementName
    httpHeaders: {
      Host: [ '{{apim-global-host-name}}' ]
    }
    name: api.outputs.name
    url: 'https://localhost/${api.outputs.relativeUri}'
  }
}
