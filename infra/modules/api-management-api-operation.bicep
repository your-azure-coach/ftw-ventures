// Scope
targetScope = 'resourceGroup'

param id string
param displayName string
param apiName string
param apimName string
param httpMethod string
param urlTemplate string
param requestSchemaName string = ''
param responseSchemaName string = ''
param policyXml string = ''

var schemaId = 'schema'

// Refer to existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' existing = {
  name: apiName
  parent: apiManagement
}


// Describe API operation
resource operation 'Microsoft.ApiManagement/service/apis/operations@2022-04-01-preview' = {
  name: id
  parent: api
  properties: {
    displayName: displayName
    method: httpMethod
    urlTemplate: urlTemplate
    request : (empty(requestSchemaName)) ? null : {
      representations: [
        {
          contentType: 'application/json'
          schemaId: schemaId
          typeName: requestSchemaName
        }
      ]
    } 
    responses: (empty(responseSchemaName)) ? null : [
      {
        statusCode: 200
        representations: [
          {
            contentType: 'application/json'
            schemaId: schemaId
            typeName: responseSchemaName
          }
        ]
      }
    ]
  }
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
