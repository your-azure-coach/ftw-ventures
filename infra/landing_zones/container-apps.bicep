targetScope = 'subscription'

//Parameters

param location string
param logAnalyticsWorkspaceId string
param deploymentId string

param containerAppsEnvironment_alreadyExists bool
param containerAppsEnvironment_name string = ''
param containerAppsEnvironment_resourceGroupName string = ''
param containerAppsEnvironment_subnetId string = ''

param networking_allowPublicAccess bool
param networking_enablePrivateAccess bool
param networking_allowAzureServices bool


//Reference existing resources
resource containerAppsEnvironmentResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: containerAppsEnvironment_resourceGroupName
}

//Define Container Apps Environment
module containerAppsEnvironment '../modules/container-apps-environment.bicep' = if(containerAppsEnvironment_alreadyExists == false) {
  scope: containerAppsEnvironmentResourceGroup
  name: 'cae-${take(containerAppsEnvironment_name, 45)}-${deploymentId}'
  params: {
    name: containerAppsEnvironment_name
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enablePrivateAccess: networking_enablePrivateAccess
    subnetId: containerAppsEnvironment_subnetId
  }
}
