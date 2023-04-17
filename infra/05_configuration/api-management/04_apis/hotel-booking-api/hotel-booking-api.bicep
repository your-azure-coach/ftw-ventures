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
  name: 'shared-infra-hotel-booking-api${deploymentId}'
  params: {
    envName: envName
  }
}

module naming '../../../../infra-naming.bicep' = {
  name: 'naming-hotel-booking-api-${deploymentId}'
  params: {
    envName: envName
    purpose: 'app-hotels'
  }
}

//Reference existing resource
resource hotelBookingApiContainerApp 'Microsoft.App/containerApps@2022-06-01-preview' existing = {
  name: replace(replace(infraParameters.naming.containerApp, '{purpose}', 'hotel-booking'), '{env}', envName)
  scope: az.resourceGroup(replace(infraParameters.resourceGroups['app-hotels'], '{env}', envName))
}

//Describe API
module api '../../../../modules/api-management-api.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-booking-api-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    displayName: 'Hotel Booking API'
    id: 'hotel-booking-api'
    path: 'hotel-booking-api'
    requiresSubscription: false
    subscriptionKeyName: parameters[envKey].subscriptionKeyName
    type: 'graphql'
    protocols: [
      'https'
      'wss'
    ]
    definitionUrl: 'https://${hotelBookingApiContainerApp.properties.configuration.ingress.fqdn}/graphql'
    version: 'v1'
    tags: [ 'System' ]
  }
}

//Describe API Backend for local routing
module apiBackend '../../../../modules/api-management-backend.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-booking-backend-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    httpHeaders: {
      Host: [ '{{apim-global-host-name}}' ]
    }
    name: api.outputs.name
    url: 'https://localhost/${api.outputs.relativeUri}'
  }
}

//Describe Application Insights Logger
module apiLogger '../../../../modules/api-management-app-insights-api-logger.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-hotel-booking-api-logger-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    apiName: api.outputs.name
    applicationInsightsId: resourceId(infraParameters.subscriptions[envKey], replace(infraParameters.resourceGroups['real-estate'], '{env}', envName), 'Microsoft.Insights/components', naming.outputs.applicationInsightsName)
    instrumentationKeyNamedValueName: 'api-${api.outputs.name}-appinsights-instrumentationKey'
    instrumentationKeySecretUri: 'https://${naming.outputs.keyVaultName}${environment().suffixes.keyvaultDns}/secrets/APPINSIGHTS--INSTRUMENTATIONKEY'
    loggerName: '${api.outputs.name}-logger'
    logHttpBodies: parameters[envKey].logHttpBodies
    verbosity: parameters[envKey].logVerbosity
  }
}
