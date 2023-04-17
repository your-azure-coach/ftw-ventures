//Describe Parameters
param env string

//Describe Named Values
module namedValues '../../../modulxes/api-management-named-values.bicep' =  {
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
