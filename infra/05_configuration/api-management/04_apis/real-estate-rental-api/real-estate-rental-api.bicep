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
  name: 'shared-infra-real-estate-rental-api-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resource
resource realEstateRentalApiWebApp  'Microsoft.Web/sites@2022-03-01' existing = {
  name: replace(replace(sharedParameters.naming.appService, '{purpose}', 'real-estate-rental'), '{env}', envName)
  scope: az.resourceGroup(replace(sharedParameters.resourceGroups['real-estate'], '{env}', envName))
}

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-rental-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
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
    definitionUrl: 'https://${realEstateRentalApiWebApp.properties.enabledHostNames[0]}/graphql'
    version: 'v1'
    tags: [ 'System' ]
    policyXml: loadTextContent('policies/api.xml')
  }
}

//Describe API Backend for local routing
module apiBackend '../../../../modules/api-management-backend.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-rental-backend-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    httpHeaders: {
      Host: [ '{{apim-global-host-name}}' ]
    }
    name: api.outputs.name
    url: 'https://localhost/${api.outputs.relativeUri}'
  }
}
