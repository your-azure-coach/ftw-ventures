// Scope
targetScope = 'resourceGroup'

// Parameters
param apimName string 
@allowed([ 'global' ])
param policyScope string
param policyXml string

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Define GLOBAL policy
resource globalPolicy 'Microsoft.ApiManagement/service/policies@2022-04-01-preview' = if(policyScope == 'global') {
  name: 'policy'
  parent: apiManagement
  properties: {
    format: 'xml'
    value: policyXml
  }
}
