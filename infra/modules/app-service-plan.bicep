// Scope
targetScope = 'resourceGroup'

// Parameters
@allowed([
  'F1'  
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'I1'
  'I2'
  'I3'
  'P1v2'
  'P2v2'
  'P3v2'
  'PC1'
  'PC2'
  'PC3'
  'PC4'
  'EP1'
  'EP2'
  'EP3'
  'EI1'
  'EI2'
  'EI3'
  'U1'
  'U2'
  'U3'
  'Y1'
])
param sku string
param name string
param location string


resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
} 

output id string = appServicePlan.id
output sku string = appServicePlan.sku.name
