// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param apimName string 
@allowed([ 'json', 'xml' ])
param schemaType string
param schemaContent object

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Define GLOBAL policy
resource schema 'Microsoft.ApiManagement/service/schemas@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    schemaType: schemaType
    document: any(schemaContent)
  }
}

output id string = schema.id
output name string = name
