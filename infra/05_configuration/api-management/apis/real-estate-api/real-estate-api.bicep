//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
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
  name: 'apim-real-estate-api-${deploymentId}'
  params: {
    apimName: apiManagementName
    displayName: 'Real Estate API'
    id: 'real-estate-api'
    path: 'real-estate-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'openapi'
    protocols: [
      'https'
    ]
    version: version
    tags: [ 'Process' ]
    policyXml: loadTextContent('policies/api.xml')
  }
}

//Describe Operations
var operations = [
  {
    id: 'get-rental-apartments'
    displayName: 'GET rental apartments'
    httpMethod: 'GET'
    urlTemplate: '/rental/apartments'
    policyXml: loadTextContent('policies/operation-get-rental-apartments.xml')
  }
  {
    id: 'get-rental-houses'
    displayName: 'GET rental houses'
    httpMethod: 'GET'
    urlTemplate: '/rental/houses'
    policyXml: loadTextContent('policies/operation-get-rental-houses.xml')
  }
  {
    id: 'get-sales-apartments'
    displayName: 'GET apartments for sale'
    httpMethod: 'GET'
    urlTemplate: '/sales/apartments'
    policyXml: loadTextContent('policies/operation-get-sales-apartments.xml')
  }
  {
    id: 'get-sales-houses'
    displayName: 'GET houses for sale'
    httpMethod: 'GET'
    urlTemplate: '/sales/houses'
    policyXml: loadTextContent('policies/operation-get-sales-houses.xml')
  }
]

module apiOperations '../../../../modules/api-management-api-operation.bicep' = [for operation in operations: {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-operation-${operation.id}-${deploymentId}'
  params: {
    id: operation.id
    apiName: api.outputs.name
    apimName: apiManagementName
    displayName: operation.displayName
    httpMethod: operation.httpMethod
    urlTemplate: operation.urlTemplate
    policyXml: operation.policyXml
  }
}]
