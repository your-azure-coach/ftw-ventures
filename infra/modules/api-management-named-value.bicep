// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param value string 
param apimName string

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Define named value
resource namedValue 'Microsoft.ApiManagement/service/namedValues@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    displayName: name
    value: value
  }
}

