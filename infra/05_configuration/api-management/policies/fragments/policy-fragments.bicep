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
module inboundGlobalRequestIdFragment  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-inbound-global-request-id-${deploymentId}'
  params: {
    name: 'inbound-global-request-id'
    fragmentXml: loadTextContent('inbound-global-request-id.xml')
    description: 'Adds a unique Request Id to every incoming API request and tracks it explicitly.'
    apimName: apiManagementName
  }
}

module outboundGlobalRequestIdFragment  '../../../../modules/api-management-policy-fragment.bicep' = {
  name: 'apim-fragment-outbound-global-request-id-${deploymentId}'
  params: {
    name: 'outbound-global-request-id'
    fragmentXml: loadTextContent('outbound-global-request-id.xml')
    description: 'Adds a unique Request Id to every outgoing API response.'
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


