// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
@allowed([ 'web', 'other'])
param kind string
param logAnalyticsWorkspaceId string
param location string


// Resources
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: kind
  properties: {
    Application_Type:  kind
    WorkspaceResourceId: logAnalyticsWorkspaceId    
  }
}

output name string = name
output id string = applicationInsights.id
