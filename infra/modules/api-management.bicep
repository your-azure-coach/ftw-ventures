// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
@allowed([
  'Developer'
  'Standard'
  'Premium'
])
param sku string
@allowed([
  1
  2
])
param instances int = 1
param allowPublicAccess bool
param enablePrivateAccess bool
param subnetId string = ''
param location string = resourceGroup().location
param publisherName string
param publisherEmail string
param userAssignedIdentityId string
param publicIpAddressName string = '${name}-pip'

// Define variables
var networkMode = (allowPublicAccess == true && enablePrivateAccess == false) ? 'None' : (allowPublicAccess == true && enablePrivateAccess == true) ? 'External' : 'Internal'

// Describe API Management public IP address
resource apimPublicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = if(networkMode != 'None') {
  name: publicIpAddressName
  sku: {
   name:  'Standard'
   tier:   'Regional'
  }
  location: location
  properties: {
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: name
    }
    publicIPAllocationMethod: 'Static'
  }  
}

// Describe API Management service
resource apiManagementService 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
    capacity: instances
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}' : {}
    }
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: publisherEmail
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    publicIpAddressId: (networkMode == 'None') ? null : apimPublicIp.id
    virtualNetworkConfiguration: (enablePrivateAccess) ? {
      subnetResourceId: subnetId
    } : null
    virtualNetworkType: networkMode
  }
}

output name string = name
