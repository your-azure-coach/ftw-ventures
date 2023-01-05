// Scope
targetScope = 'resourceGroup'

param name string
param apimName string
param url string
param httpHeaders object = {}


// Refer to existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

// Resources
resource backend 'Microsoft.ApiManagement/service/backends@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    protocol: 'http'
    url: url
    credentials: {
      header: httpHeaders
    }
  }
}
