// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param apimName string 
param fragmentXml string
param description string = ''

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Define policy fragment
resource policyFragment 'Microsoft.ApiManagement/service/policyFragments@2022-04-01-preview' = {
  name: name
  parent: apiManagement
  properties: {
    value: fragmentXml
    format:  'rawxml'
    description: description
  }
}
