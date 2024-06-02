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
  name: 'shared-infra-hotel-api-${deploymentId}'
  params: {
    envName: envName
  }
}

module naming '../../../../infra-naming.bicep' = {
  name: 'naming-hotel-api-${deploymentId}'
  params: {
    envName: envName
    purpose: 'app-hotels'
  }
}

//Describe Messaging API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-messaging-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Messaging API'
    id: 'messaging-api'
    version: 'v1'
    path: 'messaging-api'
    requiresSubscription: parameters[envKey].requireSubscriptions
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'openapi'
    protocols: [
      'https'
    ]
    policyXml: loadTextContent('policies/api.xml')
  }
}

var schemas = {
  'header.v1': loadJsonContent('schemas/common/header.v1.json')
  'customer.onboarded.v1': loadJsonContent('schemas/events/customer.onboarded.v1.json')
  'invoice.booked.v1': loadJsonContent('schemas/events/invoice.booked.v1.json')
  'project.won.v1': loadJsonContent('schemas/events/project.won.v1.json')
}

//Upload API schemas
module apiSchemas '../../../../modules/api-management-api-schemas.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-messaging-api-schemas-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    apiName: api.outputs.name
    schemas: schemas
  }
  dependsOn: [ api ]
}

//List Operations
var events = [
  {
    schemaName: 'customer.onboarded.v1'
  }
  {
    schemaName: 'invoice.booked.v1'
  }
  {
    schemaName: 'project.won.v1'
  }
]

//Describe Event Operations
module eventOperations '../../../../modules/api-management-api-operation.bicep' = [for (event, i) in events: {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-operation-${event.schemaName}-${deploymentId}'
  params: {
    id: replace(event.schemaName, '.', '-')
    apiName: api.outputs.name
    apimName: shared.outputs.apiManagementName
    displayName: 'Event ${event.schemaName}'
    httpMethod: 'POST'
    urlTemplate: 'event/${event.schemaName}'
    requestSchemaName: event.schemaName
  }
  dependsOn: [ apiSchemas ]
}]
