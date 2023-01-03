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
    deploymentId: deploymentId
  }
}

module sharedInfra '03_shared_infra/shared-infra.bicep' = {
  name: 'shared-infra-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [ governance ]
}

module application '04_applications/applications.bicep' = {
  name: 'applications-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [ sharedInfra ]
}

module configuration '05_configuration/configuration.bicep' = {
  name: 'configuration-${deploymentId}'
  params: {
    envKey: envKey
    envName: envName
    deploymentId: deploymentId
  }
  dependsOn: [ application ]
}
