//Define scope
targetScope = 'resourceGroup'

//Define parameters
@allowed([ 'dev', 'tst', 'uat','prd' ])
param envKey string
param envName string
param deploymentId string = newGuid()

//Get parameters
var parameters = loadJsonContent('./networking-parameters.json')
var sharedParameters = loadJsonContent('../shared-parameters.json')

//Set variables
var location = sharedParameters.regions.primary.location
var networkingResourceGroupName = replace(sharedParameters.resourceGroups.networking, '{env}', envName)

//Reference existing resources
resource networkingResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription(sharedParameters.subscriptions[envKey])
  name: networkingResourceGroupName
}


//Define virtual network

