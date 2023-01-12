//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var parameters = loadJsonContent('../api-management-properties.json')
var sharedParameters = loadJsonContent('../../../infra-parameters.json')
var apimResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Get shared infra
module shared '../../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

//Describe Named Values
module namedValues '../../../modules/api-management-named-values.bicep' =  {
  name: 'apim-named-values-${deploymentId}'
  scope: az.resourceGroup(apimResourceGroupName)
  params: {
    apimName: shared.outputs.apiManagementName
    namedValues: {
      'apim-global-tenant-id': tenant().tenantId
      'apim-global-request-id-header-name': parameters[envKey].requestIdHttpHeaderName
      'apim-global-remove-stacktraces': string(parameters[envKey].removeStackTraces)
      'apim-global-system-api-audience': az.environment().resourceManager
      'apim-global-identity-principal-id': shared.outputs.apiManagementPrincipalId
      'apim-global-host-name': shared.outputs.apiManagementHostname
      'apim-global-developer-portal-url': shared.outputs.apiManagementDeveloperPortalUrl
    }
  }
}
