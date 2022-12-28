//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())


module appHotels 'hotels/hotels.bicep' = {
  name: 'hotels-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}
