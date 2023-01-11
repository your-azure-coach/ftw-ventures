// Scope
targetScope = 'resourceGroup'

// Parameters
param apimName string
@secure()
param addClientId string
@secure()
param aadClientSecret string


//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

resource aadIdentityProvider 'Microsoft.ApiManagement/service/identityProviders@2022-04-01-preview' = {
  name: 'aad'
  parent: apiManagement
  properties: {
    type: 'aad'
    signinTenant: az.tenant().tenantId
    allowedTenants: [ az.tenant().tenantId ]
    clientId: addClientId
    clientSecret: aadClientSecret
  }
}
