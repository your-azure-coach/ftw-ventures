// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param location string
param retentionInDays int = 90

// Resources
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output name string = logAnalyticsWorkspace.name
output id string = logAnalyticsWorkspace.id
