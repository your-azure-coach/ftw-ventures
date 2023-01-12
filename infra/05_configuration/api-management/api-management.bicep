//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())

module namedValues '01_named_values/named-values.bicep' = {
  name: 'apim-named-values-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
}

module policyFragments '02_fragments/policy-fragments.bicep' = {
  name: 'apim-policy-fragments-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    namedValues
  ]
}

module globalPolicy '03_policy/global-policy.bicep' = {
  name: 'apim-global-policy-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    policyFragments
  ]
}

module apis '04_apis/apis.bicep' = {
  name: 'apim-apis-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    globalPolicy
  ]
}

module portalConfig '06_portal_config/portal-config.bicep' = {
  name: 'apim-portal-config-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    apis
  ]
}

module portalRbac '07_portal_rbac/portal-rbac.bicep' = {
  name: 'apim-portal-rbac-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [
    portalConfig
  ]
}
