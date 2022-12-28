// Scope
targetScope = 'resourceGroup'

// Parameters
@minLength(1)
@maxLength(63)
param name string
param location string
@minLength(1)
@maxLength(128)
param serverName string

@allowed([
  'DTU_Basic_B'
  'DTU_Standard_S0'
  'DTU_Standard_S1'
  'DTU_Standard_S2'
  'DTU_Standard_S3'
  'DTU_Standard_S4'
  'DTU_Standard_S6'
  'DTU_Standard_S7'
  'DTU_Standard_S9'
  'DTU_Standard_S12'
  'DTU_Premium_P1'
  'DTU_Premium_P2'
  'DTU_Premium_P4'
  'DTU_Premium_P6'
  'DTU_Premium_P11'
  'DTU_Premium_P15'
//   VCORE-GeneralPurpose-GP_Gen5-2
// VCORE-GeneralPurpose-GP_Gen5-4
// VCORE-GeneralPurpose-GP_Gen5-6
// VCORE-GeneralPurpose-GP_Gen5-8
// VCORE-GeneralPurpose-GP_Gen5-10
])
param sku string

var sqlServerDatabaseCollation = 'SQL_Latin1_General_CP1_CI_AS'
var sqlServerDatabaseCatalogCollation =  'SQL_Latin1_General_CP1_CI_AS'

var numberOfDtus = {
  B: 5
  S0: 10
  S1: 20
  S2: 50
  S3: 100
  S4: 200
  S6: 400
  S7: 800
  S9: 1600
  S12: 3000
  P1: 125
  P2: 250
  P4: 500
  P6: 1000
  P11: 1750
  P15: 4000
}

// Parent Resources
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' existing = {
  name: serverName
}

//Describe database
resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  name: name
  parent: sqlServer
  location: location
  sku: {
    name: split(sku, '_')[1]
    tier: split(sku, '_')[1]
    capacity: numberOfDtus[split(sku, '_')[2]]
  }
  properties: {
    collation: sqlServerDatabaseCollation
    catalogCollation: sqlServerDatabaseCatalogCollation
  }
}

output name string = sqlServerDatabase.name
output connectionStringWithManagedIdentity string = 'Server=${sqlServer.properties.fullyQualifiedDomainName}; Authentication=Active Directory Managed Identity; Database=${name}'
