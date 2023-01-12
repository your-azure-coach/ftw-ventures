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

//Describe Azure AD Identity for Developer Portal
resource sharedKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: shared.outputs.keyVaultName
  scope: az.resourceGroup(shared.outputs.keyVaultResourceGroupName)
}

module portalAadIdentityProvider '../../../modules/api-management-portal-aad.bicep' = {
  scope: az.resourceGroup(apimResourceGroupName)
  name: 'apim-portal-aad-idprovider-${deploymentId}'
  params: {
    apimName: shared.outputs.apiManagementName
    addClientId: sharedKeyVault.getSecret('APIM--PORTAL--AAD--CLIENT--ID')
    aadClientSecret: sharedKeyVault.getSecret('APIM--PORTAL--AAD--CLIENT--SECRET')
  }
}

// Add global Azure AD identity provider https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-oauth2
