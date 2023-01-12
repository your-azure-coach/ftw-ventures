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
  name: 'shared-infra-real-estate-sales-api-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resource
resource realEstateSalesApiWebApp  'Microsoft.Web/sites@2022-03-01' existing = {
  name: replace(replace(sharedParameters.naming.appService, '{purpose}', 'real-estate-sales'), '{env}', envName)
  scope: az.resourceGroup(replace(sharedParameters.resourceGroups['real-estate'], '{env}', envName))
}

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-sales-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Real Estate Sales API'
    id: 'real-estate-sales-api'
    path: 'real-estate-sales-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'openapi'
    protocols: [
      'https'
    ]
    definitionUrl: 'https://${realEstateSalesApiWebApp.properties.enabledHostNames[0]}/swagger/v1/swagger.json'
    version: 'v1'
    tags: [ 'System' ]
    policyXml: loadTextContent('policies/api.xml')
  }
}

//Describe API Backend for local routing
module apiBackend '../../../../modules/api-management-backend.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-sales-backend-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    httpHeaders: {
      Host: [ '{{apim-global-host-name}}' ]
    }
    name: api.outputs.name
    url: 'https://localhost/${api.outputs.relativeUri}'
  }
}
