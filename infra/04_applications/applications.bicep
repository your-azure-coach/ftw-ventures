//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

module hotelsApp 'hotels-app/hotels-app.bicep' = {
  name: 'hotels-app-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module realEstateApp 'real-estate-app/real-estate-app.bicep' = {
  name: 'real-estate-app-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}
