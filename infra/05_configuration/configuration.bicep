//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Call modules
module apiManagement 'api-management/api-management.bicep' = {
  name: 'api-management-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
  }
}
