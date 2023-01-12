//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../../infra-parameters.json')
var parameters = loadJsonContent('../../api-management-properties.json')
var apimResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Get shared infra
module shared '../../../../infra-shared.bicep' = {
  name: 'shared-infra-hotel-api-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resource
resource hotelsApiContainerApp 'Microsoft.App/containerApps@2022-06-01-preview' existing = {
  name: replace(replace(sharedParameters.naming.containerApp, '{purpose}', 'hotel-supergraph'), '{env}', envName)
  scope: az.resourceGroup(replace(sharedParameters.resourceGroups['app-hotels'], '{env}', envName))
}

//Describe Hotels API
module hotelsApi '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Hotel API'
    id: 'hotel-api'
    path: 'hotel-api'
    requiresSubscription: parameters[envKey].requireSubscriptions
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'graphql'
    protocols: [
      'https'
      'wss'
    ]
    definitionUrl: 'https://${hotelsApiContainerApp.properties.configuration.ingress.fqdn}/graphql'
    version: 'v1'
    tags: [
      'Process'
    ]
  }
}
