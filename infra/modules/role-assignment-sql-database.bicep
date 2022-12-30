// Scope
targetScope = 'resourceGroup'

// Parameters
param scriptIdentityName string
param scriptResourceGroupName string
param sqlServerName string
param sqlDatabaseName string
param principalName string
param principalClientId string
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

// Existing deployment identity
resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' existing = {
  name: scriptIdentityName
  scope: az.resourceGroup(scriptResourceGroupName)
}

// Parent Resources
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' existing = {
  name: sqlServerName
}

// Grant access to create firewall rules (needed for the database script)
module sqlServerRoleAssignement 'role-assignment-sql-server.bicep' = {
  name: 'ra-sqls-${take(guid(sqlServerName, sqlDatabaseName, principalClientId), 42)}-${deploymentId}'
  params: {
    principalId: deploymentScriptIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    roleName: 'SQL Server Contributor'
    sqlServerName: sqlServerName
  }
}

// Grant access on the database
module sqlDatabaseRoleAssignment 'deployment-script.bicep' = {
  name: 'ra-sqldb-${take(guid(sqlDatabaseName, principalClientId), 41)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: 'deploy-sqldb-role-assignment-${guid(sqlServerName, sqlDatabaseName, principalClientId, deploymentId)}'
    scriptContent: loadTextContent('scripts/sql-database-role-assignment.ps1')
    scriptArguments: '-SqlResourceGroupName ${resourceGroup().name} -SqlServerName ${sqlServerName} -SqlServerFqdn ${sqlServer.properties.fullyQualifiedDomainName} -SqlDatabaseName ${sqlDatabaseName} -PrincipalName ${principalName} -PrincipalId ${principalClientId} -DatabaseRoles ${sqlDatabaseRoles}'
    deploymentId: deploymentId
    deploymentIdentityId: deploymentScriptIdentity.id
    location: location
  }
  dependsOn: [ sqlServerRoleAssignement ]
}
