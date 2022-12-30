//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get parameters
var parameters = loadJsonContent('./hotels-app-parameters.json')
var sharedParameters = loadJsonContent('../../infra-parameters.json')

//Set variables
var purpose = 'app-hotels'
var containerAppNames = [
  'hotel-supergraph'
  'hotel-booking'
  'hotel-pricing'
  'hotel-catalog'
]

//Describe Web App landing zone
module hotelWebApp '../../landing_zones/web-application.bicep' = {
  name: 'webapp-zone-app-hotels-${deploymentId}'
  params: {
    appConfiguration_name: replace(replace(sharedParameters.naming.appConfiguration, '{purpose}', purpose), '{env}', envName)
    appConfiguration_sku: 'standard'
    appConfiguration_enableSoftDelete: parameters[envKey].appConfigurationEnableSoftDelete
    applicationInsights_logAnalyticsName: replace(replace(sharedParameters.naming.logAnalytics, '{purpose}', sharedParameters.sharedResources.logAnalytics.purpose), '{env}', envName)
    applicationInsights_logAnalyticsResourceGroupName: replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.logAnalytics.resourceGroup], '{env}', envName)
    applicationInsights_name: replace(replace(sharedParameters.naming.applicationInsights, '{purpose}', purpose), '{env}', envName)
    containerApps_apps: [ for containerAppName in containerAppNames : {
        name: replace(replace(sharedParameters.naming.containerApp, '{purpose}', containerAppName), '{env}', envName)
        exposeOnInternet: sharedParameters.networking[envKey].allowPublicAccess
        revisionMode: 'Single'
    }]
    containerApps_environmentName: replace(replace(sharedParameters.naming.containerAppsEnvironment, '{purpose}', sharedParameters.sharedResources.containerAppsEnvironment.purpose), '{env}', envName)
    containerApps_environmentResourceGroupName: replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.containerAppsEnvironment.resourceGroup], '{env}', envName)
    containerRegistry_name: replace(replace(sharedParameters.naming.containerRegistry, '{purpose}', replace(purpose,'-', '')), '{env}', envName)
    containerRegistry_sku: parameters[envKey].containerRegistrySku
    deploymentId: deploymentId
    deploymentScripts_identityName: replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', sharedParameters.sharedResources.deploymentScripts.purpose), '{env}', envName)
    deploymentScripts_resourceGroupName: replace(sharedParameters.resourceGroups[sharedParameters.sharedResources.deploymentScripts.resourceGroup], '{env}', envName)
    keyVault_enableSoftDelete: parameters[envKey].keyVaultEnableSoftDelete 
    keyVault_name: replace(replace(sharedParameters.naming.keyVault, '{purpose}', purpose), '{env}', envName)
    keyVault_sku: parameters[envKey].keyVaultSku
    location: sharedParameters.regions.primary.location
    networking_allowAzureServices: sharedParameters.networking[envKey].allowAzureServices
    networking_allowPublicAccess: sharedParameters.networking[envKey].allowPublicAccess
    networking_enablePrivateAccess: sharedParameters.networking[envKey].enablePrivateAccess
    redisCache_name: replace(replace(sharedParameters.naming.redisCache, '{purpose}', purpose), '{env}', envName)
    redisCache_sku: parameters[envKey].redisSku
    resourceGroupName: replace(sharedParameters.resourceGroups[purpose], '{env}', envName)
    sql_adminGroupName: sharedParameters.azureActiveDirectory[parameters[envKey].sqlAdminGroupAlias].name
    sql_adminGroupObjectId: sharedParameters.azureActiveDirectory[parameters[envKey].sqlAdminGroupAlias].objectId
    sql_databaseRoles: 'db_datareader+db_datawriter+db_owner'
    sql_databases: [ {
        name: replace(replace(sharedParameters.naming.sqlDatabase, '{purpose}', purpose), '{env}', envName)
        purpose: purpose
        sku: parameters[envKey].sqlDatabaseSku
    }]
    sql_serverName: replace(replace(sharedParameters.naming.sqlServer, '{purpose}', purpose), '{env}', envName)
  }
}
