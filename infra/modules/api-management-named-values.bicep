// Scope
targetScope = 'resourceGroup'

// Parameters
param namedValues object
param apimName string

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Define named value
resource apimNamedValues 'Microsoft.ApiManagement/service/namedValues@2022-04-01-preview' = [for namedValue in items(namedValues) : {
  name: namedValue.key
  parent: apiManagement
  properties: {
    displayName: namedValue.key
    value: namedValue.value
  }
}]
