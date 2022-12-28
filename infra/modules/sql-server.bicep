// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param sqlAdminGroupName string
param sqlAdminGoupObjectId string
param location string
param userAssignedIdentityId string
param allowPublicAccess bool 
param enablePrivateAccess bool
param allowAzureServices bool
param deploymentId string
param subnetId string = ''
param endpointName string = '${name}-endpoint'
param keyVaultName string = ''
@secure()
param sqlAdminPassword string = 'P${newGuid()}!'
param sqlAdminUsernameSecretName string = 'SQL--ADMIN--USERNAME'
param sqlAdminPasswordSecretName string = 'SQL--ADMIN--PASSWORD'
var sqlAdminUsername = 'U${guid(name, resourceGroup().name)}'

// Resource
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}' : {}
    }
  }
  properties: {
    primaryUserAssignedIdentityId: userAssignedIdentityId
    minimalTlsVersion: '1.2'
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    version: '12.0'
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: false
      principalType: 'Group'
      login: sqlAdminGroupName
      sid: sqlAdminGoupObjectId
      tenantId: subscription().tenantId
    }
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

resource firewallRuleAzureServices 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = if (allowAzureServices) {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource sqlAdminUserScret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = if (keyVaultName != '') {
  name: '${keyVaultName}/${sqlAdminUsernameSecretName}'
  properties: {
    value: sqlAdminUsername
  }
  dependsOn: [sqlServer]
}

resource sqlAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = if (keyVaultName != '') {
  name: '${keyVaultName}/${sqlAdminPasswordSecretName}'
  properties: {
    value: sqlAdminPassword
  }
  dependsOn: [sqlServer]
}

module privateEndpoint 'private-endpoint.bicep' = if (enablePrivateAccess) {
  name: 'sqlServerPrivateEndpoint-${deploymentId}'
  params: {
    name: endpointName
    resourceId: sqlServer.id
    resourceType: 'SqlServer' 
    subnetId: subnetId
    location: location
  }
}

output name string = sqlServer.name
output fqdn string = sqlServer.properties.fullyQualifiedDomainName
