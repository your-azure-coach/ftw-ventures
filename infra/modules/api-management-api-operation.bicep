// Scope
targetScope = 'resourceGroup'

param id string
param displayName string
param apiName string
param apimName string
param httpMethod string
param urlTemplate string
param policyXml string

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
  }
}

// Describe API operation policy
resource operationPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2022-04-01-preview' = {
  name: 'policy'
  parent: operation
  properties: {
    value: policyXml
    format:  'rawxml'
  }
}
