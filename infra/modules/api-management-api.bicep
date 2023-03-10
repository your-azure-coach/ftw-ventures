// Scope
targetScope = 'resourceGroup'

param apimName string
param id string
param path string
param displayName string
param version string
@allowed([
  'graphql'
  'openapi'
])
param type string
param definitionUrl string = ''
param requiresSubscription bool
param protocols array = [ 'https' ]
param tags array = []
param subscriptionKeyName string
param policyXml string = ''

// Refer to existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

// Resources
resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2022-04-01-preview' = {
  name: '${id}-version-set'
  parent: apiManagement
  properties:  {
    displayName: displayName
    versioningScheme: 'Segment'
  }
}

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' = {
  name: '${id}-${version}'
  parent: apiManagement
  properties: {
    displayName: displayName
    path: path
    apiType: type
    apiVersion: version
    apiVersionSetId: apiVersionSet.id
    protocols: protocols
    subscriptionRequired: requiresSubscription
    subscriptionKeyParameterNames: {
      header: subscriptionKeyName
      query: 'D0N0tUs3Th!s'
    } 
    format: (definitionUrl != '') ? (type == 'graphql') ? 'graphql-link' : 'openapi+json-link' : null
    value: (definitionUrl != '') ? definitionUrl : null
  } 
}

resource apimTags 'Microsoft.ApiManagement/service/tags@2022-04-01-preview' = [for tag in tags: {
  name: tag
  parent: apiManagement
  properties: {
    displayName: tag
  }
}]

resource apiTags 'Microsoft.ApiManagement/service/apis/tags@2022-04-01-preview' = [for tag in tags: {
  name: tag
  parent: api
  dependsOn: [
    apimTags
  ]
}]

resource apiPolicy 'Microsoft.ApiManagement/service/apis/policies@2022-04-01-preview' = if(policyXml != '') {
  name: 'policy'
  parent: api
  properties: {
    value: policyXml
    format: 'rawxml'
  }
}

output id string = api.id
output name string = api.name
output path string = api.properties.path
output version string = api.properties.apiVersion
output relativeUri string = '${api.properties.path}/${api.properties.apiVersion}'
