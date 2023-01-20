// Scope
targetScope = 'resourceGroup'

// Parameters
param apimName string
param logAnalyticsWorkspaceId string


//Configure Log Analytics for API Management
resource logAnalyticsApimSettings 'Microsoft.ApiManagement/service/providers/diagnosticSettings@2015-07-01' = {
  name: '${apimName}/Microsoft.Insights/service'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'GatewayLogs'
        enabled: true
      }
    ]
  }
}
