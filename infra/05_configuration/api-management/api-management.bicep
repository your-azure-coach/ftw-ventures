//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var sharedParameters = loadJsonContent('../../infra-parameters.json')
var parameters = loadJsonContent('api-management-properties.json')
var apiManagementName = replace(replace(sharedParameters.naming.apiManagement, '{purpose}', sharedParameters.sharedResources.apiManagement.purpose), '{env}', envName)
var apiManagementResourceGroupName = replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apiManagementName
  scope: az.resourceGroup(apiManagementResourceGroupName)
}

//Describe Global API Management policy
module globalPolicy '../../modules/api-management-policy.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-global-policy-${deploymentId}'
  params: {
    apimName: apiManagementName
    policyScope: 'global'
    policyXml: loadTextContent('policies/global.xml')
  }
  dependsOn: [
    policyFragments
  ]
}

var nValues = {
  'apim-global-tenant-id': tenant().tenantId
  'apim-global-request-id-header-name': parameters[envKey].requestIdHttpHeaderName
  'apim-global-remove-stacktraces': string(parameters[envKey].removeStackTraces)
  'apim-global-system-api-audience': az.environment().resourceManager
}

//Describe Named Values
module namedValues '../../modules/api-management-named-value.bicep' = [for nValue in items(nValues): {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-named-value-${take(nValue.key, 33)}-${deploymentId}'
  params: {
    apimName: apiManagementName
    name: nValue.key
    value: nValue.value
  }
}]

module identityNamedValue '../../modules/api-management-named-value.bicep' =  {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-named-value-identity-${deploymentId}'
  params: {
    apimName: apiManagementName
    name: 'apim-global-identity-principal-id'
    value: apiManagement.identity.principalId
  }
}

module hostNameNamedValue '../../modules/api-management-named-value.bicep' =  {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-named-value-hostname-${deploymentId}'
  params: {
    apimName: apiManagementName
    name: 'apim-global-host-name'
    value: replace(apiManagement.properties.gatewayUrl, 'https://', '')
  }
}

//Describe Policy Fragments
module policyFragments 'policies/fragments/policy-fragments.bicep' = {
  scope: az.resourceGroup(apiManagementResourceGroupName)
  name: 'apim-policy-fragments-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
  }
  dependsOn: [
    namedValues
    identityNamedValue
  ]
}
