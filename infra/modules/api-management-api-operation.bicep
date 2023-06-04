// Scope
targetScope = 'resourceGroup'

param id string
param displayName string
param apiName string
param apimName string
param httpMethod string
param urlTemplate string
param schemaId string
param schemaContent string
param policyXml string = ''

// Refer to existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' existing = {
  name: apiName
  parent: apiManagement
}

// Describe API schema
resource apiSchema 'Microsoft.ApiManagement/service/apis/schemas@2022-04-01-preview' = {
  name: guid(schemaId)
  parent: api
  properties: {
    contentType: 'application/vnd.oai.openapi.components+json'
    document: any({
      components: {
        schemas: {
          '${schemaId}': {
              type: 'object'
              required: true
              properties: schemaContent
              example: ''
          }
        }
      }
    })
  }
}


// Describe API operation
resource operation 'Microsoft.ApiManagement/service/apis/operations@2022-04-01-preview' = {
  name: id
  parent: api
  properties: {
    displayName: displayName
    method: httpMethod
    urlTemplate: urlTemplate
    request: {
      representations: [
        {
          contentType: 'application/json'
          schemaId: guid(schemaId)
        }
      ]
    }
  }
  dependsOn: [ apiSchema ]
}





// Describe API operation policy
resource operationPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2022-04-01-preview' = if(policyXml != '') {
  name: 'policy'
  parent: operation
  properties: {
    value: policyXml
    format:  'rawxml'
  }
}
