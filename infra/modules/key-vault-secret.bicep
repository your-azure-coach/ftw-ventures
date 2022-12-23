// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
@secure()
param value string
param keyVaultName string

// Resources
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  name: name
  parent: keyVault
  properties: {
    value: value
  }
}

output name string = secret.name
output uri string = secret.properties.secretUri
output versionedUri string = secret.properties.secretUriWithVersion
