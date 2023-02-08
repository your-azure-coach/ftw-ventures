targetScope = 'subscription'

// Define parameters
param resourceGroupName string
param location string
param deploymentId string

param containerApps_environmentName string
param containerApps_environmentResourceGroupName string
param containerApps_apps array
param containerApps_connectionString string = 'API:{PURPOSE}:URI'

param containerRegistry_name string
@allowed(['Basic', 'Classic', 'Premium', 'Standard'])
param containerRegistry_sku string

param sql_serverName string
param sql_adminGroupObjectId string
param sql_adminGroupName string
param sql_adminUsernameSecretName string = 'SQL--ADMIN--USERNAME'
param sql_adminPasswordSecretName string = 'SQL--ADMIN--PASSWORD'
param sql_connectionStringName string = 'SQL:{PURPOSE}:CONNECTIONSTRING'
param sql_databases array
@allowed(['db_datareader', 'db_datawriter', 'db_owner', 'db_datareader+db_datawriter', 'db_datareader+db_owner', 'db_datawriter+db_owner', 'db_datareader+db_datawriter+db_owner'])
param sql_databaseRoles string

param redisCache_name string
@allowed(['Basic_C0', 'Basic_C1', 'Basic_C2', 'Basic_C3', 'Basic_C4', 'Basic_C5', 'Basic_C6', 'Standard_C0', 'Standard_C1', 'Standard_C2', 'Standard_C3', 'Standard_C4', 'Standard_C5', 'Standard_C6', 'Premium_P1', 'Premium_P2', 'Premium_P3', 'Premium_P4', 'Premium_P5'])
param redisCache_sku string
param redisCache_connectionStringName string = 'REDIS:CONNECTIONSTRING'
param redisCache_connectionStringSecretName string = 'REDIS--CONNECTIONSTRING'

param applicationInsights_name string
param applicationInsights_logAnalyticsName string
param applicationInsights_logAnalyticsResourceGroupName string
param applicationInsights_connectionStringName string = 'APPINSIGHTS:CONNECTIONSTRING'
param applicationInsights_connectionStringSecretName string = 'APPINSIGHTS--CONNECTIONSTRING'

param keyVault_name string
@allowed(['standard', 'premium'])
param keyVault_sku string
param keyVault_enableSoftDelete bool

param appConfiguration_name string
@allowed(['standard'])
param appConfiguration_sku string
param appConfiguration_enableSoftDelete bool

param networking_allowPublicAccess bool
param networking_enablePrivateAccess bool
param networking_allowAzureServices bool

param deploymentScripts_identityName string
param deploymentScripts_resourceGroupName string

param apiManagement_principalId string


//Reference existing resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerApps_environmentName
  scope: az.resourceGroup(containerApps_environmentResourceGroupName)
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: applicationInsights_logAnalyticsName
  scope: az.resourceGroup(applicationInsights_logAnalyticsResourceGroupName)
}

resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: deploymentScripts_identityName
  scope: az.resourceGroup(deploymentScripts_resourceGroupName)
}

//Describe Key Vault
module keyVault '../modules/key-vault.bicep' = {
  scope: resourceGroup
  name: 'kv-${take(keyVault_name, 47)}-${deploymentId}'
  params: {
    name: keyVault_name
    location: location
    sku: keyVault_sku
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    allowAzureServices: networking_allowAzureServices
    enableSoftDelete: keyVault_enableSoftDelete
    deploymentId: deploymentId
  }
}

//Describe App Configuration
module appConfiguration '../modules/app-configuration.bicep' = {
  scope: resourceGroup
  name: 'aco-${take(appConfiguration_name, 46)}-${deploymentId}'
  params: {
    name: appConfiguration_name
    location: location
    sku: appConfiguration_sku
    enableSoftDelete: appConfiguration_enableSoftDelete
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess 
    deploymentId: deploymentId    
  }
}

//Describe Application Insights
module applicationInsights '../modules/application-insights.bicep' = {
  scope: resourceGroup
  name: 'appi-${take(applicationInsights_name, 45)}-${deploymentId}'
  params: {
    name: applicationInsights_name
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.id
    kind:  'web'
    keyVaultName: keyVault.outputs.name
    appInsightsConnectionStringSecretName: applicationInsights_connectionStringSecretName
    storeInstrumentationKeyInKeyVault: true
    deploymentId: deploymentId
  }
}

//Describe Application Insights connection string
module appInsightsConnectionString '../modules/app-configuration-setting-secret.bicep' = {
  scope: resourceGroup
  name: 'appi-conn-${take(split(applicationInsights_connectionStringName, ':')[0], 40)}-${deploymentId}'
  params: {
    name: applicationInsights_connectionStringName 
    appConfigurationName: appConfiguration.outputs.name
    secretKeyVaultUri: applicationInsights.outputs.connectionStringSecretUri
  }
}

//Describe Container Registry
module containerRegistry '../modules/container-registry.bicep' = {
  scope: resourceGroup
  name: 'acr-${take(containerRegistry_name, 46)}-${deploymentId}'
  params: {
    name: containerRegistry_name
    sku: containerRegistry_sku
    allowAzureServices: networking_allowAzureServices 
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    location: location
    deploymentId: deploymentId
  }
}

//Describe Redis Cache
module redisCache '../modules/redis-cache.bicep' = {
  scope: resourceGroup
  name: 'rc-${take(redisCache_name, 47)}-${deploymentId}'
  params: {
    name: redisCache_name
    sku: redisCache_sku
    location: location
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    keyVaultName: keyVault.outputs.name 
    redisConnectionStringSecretName: redisCache_connectionStringSecretName
    deploymentId: deploymentId
  }
}

//Describe Redis Cache connection string
module redisCacheConnectionString '../modules/app-configuration-setting-secret.bicep' = {
  scope: resourceGroup
  name: 'redis-conn-${take(split(redisCache_connectionStringName, ':')[0], 39)}-${deploymentId}'
  params: {
    name: redisCache_connectionStringName 
    appConfigurationName: appConfiguration.outputs.name
    secretKeyVaultUri: redisCache.outputs.connectionStringSecretUri
  }
}

//Describe SQL Server
module sqlServer '../modules/sql-server.bicep' = {
  scope: resourceGroup
  name: 'sqls-${take(sql_serverName, 45)}-${deploymentId}'
  params: {
    name: sql_serverName
    location: location
    allowAzureServices: networking_allowAzureServices
    allowPublicAccess: networking_allowPublicAccess
    enablePrivateAccess: networking_enablePrivateAccess
    sqlAdminGoupObjectId: sql_adminGroupObjectId
    sqlAdminGroupName: sql_adminGroupName
    keyVaultName: keyVault.outputs.name   
    sqlAdminUsernameSecretName: sql_adminUsernameSecretName
    sqlAdminPasswordSecretName: sql_adminPasswordSecretName
    deploymentId: deploymentId
  }
}

//Describe SQL Database
module sqlDatabases '../modules/sql-database.bicep' = [for sqlDb in sql_databases : {
  scope: resourceGroup
  name: 'sqldb-${take(sqlDb.name, 44)}-${deploymentId}'
  params: {
    name: sqlDb.name
    serverName: sqlServer.outputs.name
    location: location
    sku: sqlDb.sku  
  }
}]

//Describe SQL Database connection string
module sqlDatabaseConnectionStrings '../modules/app-configuration-setting.bicep' = [for (sqlDb, i) in sql_databases : {
  scope: resourceGroup
  name: 'sql-conn-${take(sqlDb.purpose, 41)}-${deploymentId}'
  params: {
    appConfigurationName: appConfiguration.outputs.name
    name: replace(replace(sql_connectionStringName, '{PURPOSE}', toUpper(sqlDb.purpose)), '{purpose}', sqlDb.purpose)
    value: sqlDatabases[i].outputs.connectionStringWithManagedIdentity
  }
}]

//Describe Container App
module containerApps '../modules/container-app.bicep' = [for containerApp in containerApps_apps: {
  scope: resourceGroup
  name: 'ca-${take(containerApp.name, 47)}-${deploymentId}'
  params: {
    name: containerApp.name
    location: location
    allowPublicAccess: contains(containerApp, 'exposeOnInternet') ? containerApp.exposeOnInternet : false
    containerRegistryName: containerRegistry.outputs.name
    environmentId: containerAppsEnvironment.id
    revisionMode: contains(containerApp, 'revisionMode') ? containerApp.revisionMode : 'Single'
    deploymentId: deploymentId
    scriptIndentityId: deploymentScriptIdentity.id
    scriptResourceGroupName: deploymentScripts_resourceGroupName
  }
}]

//Describe Container Apps URIs
module containerAppsUris '../modules/app-configuration-setting.bicep' = [for (containerApp, i) in containerApps_apps : {
  scope: resourceGroup
  name: 'ca-conn-${take(containerApp.purpose, 42)}-${deploymentId}'
  params: {
    appConfigurationName: appConfiguration.outputs.name
    name: replace(replace(containerApps_connectionString, '{PURPOSE}', toUpper(containerApp.purpose)), '{purpose}', containerApp.purpose)
    value: 'https://${containerApps[i].outputs.fqdn}'
  }
}]

//Grant Container Apps rights to read Key Vault secrets
module keyVaultRoleAssignments '../modules/role-assignment-key-vault.bicep' = [for (containerApp, i) in containerApps_apps:{
  scope: resourceGroup
  name: 'ra-${guid(keyVault_name, containerApp.name, 'Secrets User')}-${deploymentId}'
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: containerApps[i].outputs.principalId
    principalType: 'ServicePrincipal'
    roleName: 'Key Vault Secrets User'
  }
}]

//Grant API Management rights to read Key Vault secrets
module apiManagementKeyVaultRoleAssignment '../modules/role-assignment-key-vault.bicep' = {
  scope: resourceGroup
  name: 'ra-${guid('apim', 'App Configuration Data Reader')}-${deploymentId}'
  params: {
    keyVaultName: keyVault_name
    principalId: apiManagement_principalId
    principalType: 'ServicePrincipal'
    roleName: 'Key Vault Secrets User'
  }
}

//Grant Container Apps rights to Read App Configuration data
module appConfigurationRoleAssignments '../modules/role-assignment-app-configuration.bicep' = [for (containerApp, i) in containerApps_apps: {
  scope: resourceGroup
  name: 'ra-${guid(appConfiguration_name, containerApp.name, 'App Configuration Data Reader')}-${deploymentId}'
  params: {
    appConfigurationName: appConfiguration.outputs.name
    principalId: containerApps[i].outputs.principalId
    principalType: 'ServicePrincipal'
    roleName: 'App Configuration Data Reader'
  }
}]

//Grant Container Apps access to SQL Databases
module sqlDatabaseRoleAssignments '../modules/role-assignment-sql-database-array.bicep' = [for (sqlDb, i) in sql_databases : {
  scope: resourceGroup
  name: 'sql-role-${take(sqlDb.name, 41)}-${deploymentId}'
  params: {
    deploymentId: deploymentId
    location: location
    principals: [ for (containerApp, i) in containerApps_apps: {
      name: containerApp.name
      appId: containerApps[i].outputs.principalAppId
    }]
    sqlServerName: sqlServer.outputs.name
    sqlDatabaseName: sqlDatabases[i].outputs.name
    sqlDatabaseRoles: sql_databaseRoles
    scriptIdentityName: deploymentScripts_identityName
    scriptResourceGroupName: deploymentScripts_resourceGroupName
  }
}]
