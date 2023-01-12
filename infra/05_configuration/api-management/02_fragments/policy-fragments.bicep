//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../infra-parameters.json')
var apimResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Get shared infra
module shared '../../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

//Describe Policy Fragments
module inboundRequestIdFragment  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-global-request-id-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'inbound-request-id'
    fragmentXml: loadTextContent('fragments/inbound-request-id.xml')
    description: 'Adds a unique Request Id HTTP Header (name configured via named value) to every incoming API request and tracks it explicitly.'
    apimName: shared.outputs.apiManagementName
  }
}

module outboundRequestIdFragment  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-outbound-global-request-id-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'outbound-request-id'
    fragmentXml: loadTextContent('fragments/outbound-request-id.xml')
    description: 'Adds a unique Request Id HTTP Header (name configured via named value) to every outgoing API response.'
    apimName: shared.outputs.apiManagementName
  }
}

module errorRemoveStacktraces  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-error-remove-stacktraces-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'error-remove-stacktraces'
    fragmentXml: loadTextContent('fragments/error-remove-stacktraces.xml')
    description: 'Removes stacktraces on exceptions, if enabled via named value.'
    apimName: shared.outputs.apiManagementName
  }
}

module authenticateSystemApi  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-authenticate-system-api-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'inbound-authenticate-system-api'
    fragmentXml: loadTextContent('fragments/inbound-authenticate-system-api.xml')
    description: 'Authenticates with Managed Identity against the System APIs.'
    apimName: shared.outputs.apiManagementName
  }
}

module authorizeSystemApi  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-authorize-system-api-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'inbound-authorize-system-api'
    fragmentXml: loadTextContent('fragments/inbound-authorize-system-api.xml')
    description: 'Authorizes System APIs to ensure only API Management can consume them.'
    apimName: shared.outputs.apiManagementName
  }
}

module corsDeveloperPortal  '../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-cors-developer-portal-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    name: 'inbound-cors-developer-portal'
    fragmentXml: loadTextContent('fragments/inbound-cors-developer-portal.xml')
    description: 'Configures CORS to allow requests from the built-in Developer Portal.'
    apimName: shared.outputs.apiManagementName
  }
}
