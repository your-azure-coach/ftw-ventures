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
  name: 'shared-infra-hotel-catalog-api-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resource
resource hotelCatalogApiContainerApp 'Microsoft.App/containerApps@2022-06-01-preview' existing = {
  name: replace(replace(sharedParameters.naming.containerApp, '{purpose}', 'hotel-supergraph'), '{env}', envName)
  scope: az.resourceGroup(replace(sharedParameters.resourceGroups['app-hotels'], '{env}', envName))
}

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-catalog-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Hotel Catalog API'
    id: 'hotel-catalog-api'
    path: 'hotel-catalog-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'graphql'
    protocols: [
      'https'
      'wss'
    ]
    definitionUrl: 'https://${hotelCatalogApiContainerApp.properties.configuration.ingress.fqdn}/graphql'
    version: 'v1'
    tags: [
      'System'
    ]
  }
}

//Describe API Backend for local routing
module apiBackend '../../../../modules/api-management-backend.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-catalog-backend-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    httpHeaders: {
      Host: [ '{{apim-global-host-name}}' ]
    }
    name: api.outputs.name
    url: 'https://localhost/${api.outputs.relativeUri}'
  }
}