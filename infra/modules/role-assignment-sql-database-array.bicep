// Scope
targetScope = 'resourceGroup'

// Parameters
param scriptIdentityName string
param scriptResourceGroupName string
param sqlServerName string
param sqlDatabaseName string
param principals array
@allowed([
  'db_datareader'
  'db_datawriter'
  'db_owner'
  'db_datareader+db_datawriter'
  'db_datareader+db_owner'
  'db_datawriter+db_owner'
  'db_datareader+db_datawriter+db_owner'
])
param sqlDatabaseRoles string
param location string
param deploymentId string

module sqlDatabaseRoleAssignments 'role-assignment-sql-database.bicep' = [for principal in principals: {
  name: 'ra-sql-${take(guid(sqlDatabaseName, principal.clientId), 43)}-${deploymentId}'
  params: {
    deploymentId: deploymentId
    location: location
    principalClientId: principal.clientId
    principalName: principal.name
    scriptIdentityName: scriptIdentityName
    scriptResourceGroupName: scriptResourceGroupName
    sqlDatabaseName: sqlDatabaseName
    sqlDatabaseRoles: sqlDatabaseRoles
    sqlServerName: sqlServerName
  }
}]
