// Scope
targetScope = 'resourceGroup'

param schemas object
param apiName string
param apimName string

var schemaId = 'schema'

// Refer to existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' existing = {
  name: apiName
  parent: apiManagement
}

// Resources
resource apiSchemas 'Microsoft.ApiManagement/service/apis/schemas@2023-05-01-preview' = {
  name: schemaId
  parent: api
  properties: {
    contentType: 'application/vnd.oai.openapi.components+json'
    document: {
      components: {
        schemas: schemas
      }
    }
  }
}

output id string = schemaId
