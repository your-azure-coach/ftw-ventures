//Define scope
targetScope = 'subscription'

//Define parameters
@allowed([ 'dev', 'tst', 'uat', 'prd' ])
param envKey string
param envName string
param deploymentId string = uniqueString(newGuid())


module governance '01_governance/governance.bicep' = {
  name: 'governance-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
  }
}

module sharedInfra '03_shared_infra/shared-infra.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
  }
  dependsOn: [ governance ]
}
