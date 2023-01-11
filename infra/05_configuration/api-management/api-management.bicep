//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Define variables
var parameters = loadJsonContent('api-management-properties.json')
var sharedParameters = loadJsonContent('../../infra-parameters.json')

//Get shared infra
module shared '../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

//Reference existing resources
resource apimResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.apiManagement.resourceGroup], '{env}', envName)
}

//Describe Global API Management policy
module globalPolicy '../../modules/api-management-policy.bicep' = {
  scope: apimResourceGroup
  name: 'apim-global-policy-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
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
  scope: apimResourceGroup
  name: 'apim-named-value-${take(nValue.key, 33)}-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    name: nValue.key
    value: nValue.value
  }
}]

module identityNamedValue '../../modules/api-management-named-value.bicep' =  {
  scope: apimResourceGroup
  name: 'apim-named-value-identity-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    name: 'apim-global-identity-principal-id'
    value: shared.outputs.apiManagementPrincipalId
  }
}

module hostNameNamedValue '../../modules/api-management-named-value.bicep' =  {
  scope: apimResourceGroup
  name: 'apim-named-value-hostname-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    name: 'apim-global-host-name'
    value: shared.outputs.apiManagementHostname
  }
}

//Describe Policy Fragments
module policyFragments 'policies/fragments/policy-fragments.bicep' = {
  scope: apimResourceGroup
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

//Describe Azure AD Identity for Developer Portal
resource sharedKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: shared.outputs.keyVaultName
  scope: az.resourceGroup(shared.outputs.keyVaultResourceGroupName)
}

module portalAadIdentityProvider '../../modules/api-management-portal-aad.bicep' = {
  scope: apimResourceGroup
  name: 'apim-portal-aad-idprovider-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    addClientId: sharedKeyVault.getSecret('APIM--PORTAL--AAD--CLIENT--ID')
    aadClientSecret: sharedKeyVault.getSecret('APIM--PORTAL--AAD--CLIENT--SECRET')
  }
}

// Add global Azure AD identity provider https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-oauth2
