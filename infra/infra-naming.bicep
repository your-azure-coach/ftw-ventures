//Define scope
targetScope = 'subscription'

//Define parameters
param envName string
param purpose string

//Get shared parameters
var sharedParameters = loadJsonContent('infra-parameters.json')

//Return resources
output appConfigurationName string = replace(replace(sharedParameters.naming.appConfiguration, '{purpose}', purpose), '{env}', envName)
output applicationInsightsName string = replace(replace(sharedParameters.naming.applicationInsights, '{purpose}', purpose), '{env}', envName)
output appServiceName string = replace(replace(sharedParameters.naming.appService, '{purpose}', purpose), '{env}', envName)
output appServiceNameWithPlaceholder string = replace(replace(sharedParameters.naming.appService, '{purpose}', '${purpose}-{purpose}'), '{env}', envName)
output appServicePlanName string = replace(replace(sharedParameters.naming.appServicePlan, '{purpose}', purpose), '{env}', envName)
output budgetAlertName string = replace(replace(sharedParameters.naming.budgetAlert, '{purpose}', purpose), '{env}', envName)
output containerAppName string = replace(replace(sharedParameters.naming.containerApp, '{purpose}', purpose), '{env}', envName)
output containerInstanceName string = replace(replace(sharedParameters.naming.containerInstance, '{purpose}', purpose), '{env}', envName)
output containerRegistryName string = replace(replace(sharedParameters.naming.containerRegistry, '{purpose}', replace(purpose, '-', '')), '{env}', envName)
output deploymentScriptName string = replace(replace(sharedParameters.naming.deploymentScript, '{purpose}', purpose), '{env}', envName)
output keyVaultName string = replace(replace(sharedParameters.naming.keyVault, '{purpose}', purpose), '{env}', envName)
output logicAppName string = replace(replace(sharedParameters.naming.logicApp, '{purpose}', purpose), '{env}', envName)
output managedIdentityName string = replace(replace(sharedParameters.naming.managedIdentity, '{purpose}', purpose), '{env}', envName)
output publicIpAddressName string = replace(replace(sharedParameters.naming.publicIpAddress, '{purpose}', purpose), '{env}', envName)
output redisCacheName string = replace(replace(sharedParameters.naming.redisCache, '{purpose}', purpose), '{env}', envName)
output sqlDatabaseName string = replace(replace(sharedParameters.naming.sqlDatabase, '{purpose}', purpose), '{env}', envName)
output sqlServerName string = replace(replace(sharedParameters.naming.sqlServer, '{purpose}', purpose), '{env}', envName)
output storageAccountName string = replace(replace(sharedParameters.naming.storageAccount, '{purpose}', replace(purpose, '-', '')), '{env}', envName)
