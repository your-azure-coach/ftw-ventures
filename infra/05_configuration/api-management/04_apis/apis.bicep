//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

//Get shared infra
module shared '../../../infra-shared.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envName: envName
  }
}

module hotelBookingApi 'hotel-booking-api/hotel-booking-api.bicep' = {
  name: 'hotel-booking-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module hotelCatalogApi 'hotel-catalog-api/hotel-catalog-api.bicep' = {
  name: 'hotel-catalog-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module hotelPricingApi 'hotel-pricing-api/hotel-pricing-api.bicep' = {
  name: 'hotel-pricing-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module hotelApi 'hotel-api/hotel-api.bicep' = {
  name: 'hotel-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    hotelBookingApi
    hotelCatalogApi
    hotelPricingApi
  ]
}

module realEstateSalesApi 'real-estate-sales-api/real-estate-sales-api.bicep' = {
  name: 'real-estate-sales-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module realEstateRentalApi 'real-estate-rental-api/real-estate-rental-api.bicep' = {
  name: 'real-estate-rental-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module realEstateApi 'real-estate-api/real-estate-api.bicep' = {
  name: 'real-estate-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    realEstateRentalApi
    realEstateSalesApi
  ]
}

module messagingApi 'messaging-api/messaging-api.bicep' = {
  name: 'messaging-api-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}
