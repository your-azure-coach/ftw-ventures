//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var infraParameters = loadJsonContent('../../../../infra-parameters.json')
var parameters = loadJsonContent('../../api-management-properties.json')
var apimResourceGroupName = replace(infraParameters.resourceGroups[infraParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Get shared infra
module shared '../../../../infra-shared.bicep' = {
  name: 'shared-infra-real-estate-api-${deploymentId}'
  params: {
    envName: envName
  }
}

module naming '../../../../infra-naming.bicep' = {
  name: 'naming-infra-real-estate-api-${deploymentId}'
  params: {
    envName: envName
    purpose: 'real-estate'
  }
}

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Real Estate API'
    id: 'real-estate-api'
    path: 'real-estate-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'openapi'
    protocols: [
      'https'
    ]
    version: 'v1'
    tags: [ 'Process' ]
    policyXml: loadTextContent('policies/api.xml')
  }
}

//Describe Application Insights Logger
module apiLogger '../../../../modules/api-management-app-insights-api-logger.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-real-estate-api-logger-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    apiName: api.outputs.name
    applicationInsightsId: resourceId(infraParameters.subscriptions[envKey], replace(infraParameters.resourceGroups['real-estate'], '{env}', envName), 'Microsoft.Insights/components', naming.outputs.applicationInsightsName)
    instrumentationKeyNamedValueName: '${api.outputs.name}-appinsights-instrumentationKey'
    instrumentationKeySecretUri: 'https://${naming.outputs.keyVaultName}${environment().suffixes.keyvaultDns}/secrets/APPINSIGHTS--INSTRUMENTATIONKEY'
    loggerName: '${api.outputs.name}-logger'
    logHttpBodies: parameters[envKey].logHttpBodies
    verbosity: parameters[envKey].logVerbosity
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
  {
    id: 'operation-post-house'
    displayName: 'REGISTER new house'
    httpMethod: 'POST'
    urlTemplate: 'house'
    policyXml: loadTextContent('policies/operation-post-house.xml') 
  }
]

module apiOperations '../../../../modules/api-management-api-operation.bicep' = [for operation in operations: {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-operation-${operation.id}-${deploymentId}'
  params: {
    id: operation.id
    apiName: api.outputs.name
    apimName: shared.outputs.apiManagementName
    displayName: operation.displayName
    httpMethod: operation.httpMethod
    urlTemplate: operation.urlTemplate
    policyXml: operation.policyXml
  }
}]
