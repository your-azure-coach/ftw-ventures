//Define scope
targetScope = 'resourceGroup'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../../../infra-parameters.json')
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)

//Describe Policy Fragments
module inboundRequestIdFragment  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-global-request-id-${deploymentId}'
  params: {
    name: 'inbound-request-id'
    fragmentXml: loadTextContent('inbound-request-id.xml')
    description: 'Adds a unique Request Id HTTP Header (name configured via named value) to every incoming API request and tracks it explicitly.'
    apimName: apiManagementName
  }
}

module outboundRequestIdFragment  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-outbound-global-request-id-${deploymentId}'
  params: {
    name: 'outbound-request-id'
    fragmentXml: loadTextContent('outbound-request-id.xml')
    description: 'Adds a unique Request Id HTTP Header (name configured via named value) to every outgoing API response.'
    apimName: apiManagementName
  }
}

module errorRemoveStacktraces  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-error-remove-stacktraces-${deploymentId}'
  params: {
    name: 'error-remove-stacktraces'
    fragmentXml: loadTextContent('error-remove-stacktraces.xml')
    description: 'Removes stacktraces on exceptions, if enabled via named value.'
    apimName: apiManagementName
  }
}

module authenticateSystemApi  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-authenticate-system-api-${deploymentId}'
  params: {
    name: 'inbound-authenticate-system-api'
    fragmentXml: loadTextContent('inbound-authenticate-system-api.xml')
    description: 'Authenticates with Managed Identity against the System APIs.'
    apimName: apiManagementName
  }
}

module authorizeSystemApi  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-authorize-system-api-${deploymentId}'
  params: {
    name: 'inbound-authorize-system-api'
    fragmentXml: loadTextContent('inbound-authorize-system-api.xml')
    description: 'Authorizes System APIs to ensure only API Management can consume them.'
    apimName: apiManagementName
  }
}


