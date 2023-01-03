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

//Describe Hotels API
module hotelsApi '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-hotel-pricing-api-${deploymentId}'
  params: {
    apimName: apiManagementName
    displayName: 'Hotel Pricing API'
    id: 'hotel-pricing-api'
    path: 'hotel-pricing-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'graphql'
    protocols: [
      'https'
      'wss'
    ]
    definitionUrl: definitionUrl
    version: version
    tags: [
      'System'
    ]
  }
}
