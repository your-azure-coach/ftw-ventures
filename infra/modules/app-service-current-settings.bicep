// Scope
targetScope = 'resourceGroup'

// Parameters
param name string

output appSettings object = list('Microsoft.Web/sites/${name}/config/appsettings', '2020-06-01').properties
