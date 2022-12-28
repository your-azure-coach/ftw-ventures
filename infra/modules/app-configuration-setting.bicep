// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param value string
param appConfigurationName string

// Reference existing resources
resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' existing = {
  name: appConfigurationName
}

// Describe setting
resource appConfigurationSetting 'Microsoft.AppConfiguration/configurationStores/keyValues@2022-05-01' = {
  name: name
  parent: appConfiguration
  properties: {
    value: value
  }
}
