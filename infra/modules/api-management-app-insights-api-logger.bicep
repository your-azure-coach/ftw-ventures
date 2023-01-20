// Scope
targetScope = 'resourceGroup'

// Parameters
param apimName string
param apiName string
param loggerName string
param applicationInsightsId string
param instrumentationKeyNamedValueName string
param instrumentationKeySecretUri string
param logHttpBodies bool
@allowed([ 'error', 'information', 'verbose', 'debug' ])
param verbosity string

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-04-01-preview' existing = {
  name: apiName
  parent: apiManagement
}

//Create Named Value for Instrumentation Key
resource apimAppInsightsInstrumentationKeyNamedValue 'Microsoft.ApiManagement/service/namedValues@2021-12-01-preview' = {
  name: instrumentationKeyNamedValueName
  parent: apiManagement
  properties: {
    displayName: instrumentationKeyNamedValueName
    keyVault: {
      secretIdentifier: instrumentationKeySecretUri
    }
    secret: true
  }
}

//Create a logger that uses the named value
resource apimApplicationInsightsLogger 'Microsoft.ApiManagement/service/loggers@2022-04-01-preview' = {
  name: loggerName
  parent: apiManagement
  properties: {
    loggerType: 'applicationInsights'
    isBuffered: true
    resourceId: applicationInsightsId
    credentials: {
      instrumentationKey: '{{${instrumentationKeyNamedValueName}}}'
    }
  }
  dependsOn: [ apimAppInsightsInstrumentationKeyNamedValue ]
}

resource apiApplicationInsightsSettings 'Microsoft.ApiManagement/service/apis/diagnostics@2022-04-01-preview' = {
  name: 'applicationinsights'
  parent: api
  properties: {
    alwaysLog: 'allErrors'
    backend: {
      request: {
        body: {
          bytes: logHttpBodies ? 8192 : 0
        }
        headers: [
        ]
      }
      response: {
        body: {
          bytes: logHttpBodies ? 8192 : 0
        }
        headers: [
        ]
      }
    }
    frontend: {
      request: {
        body: {
          bytes: logHttpBodies ? 8192 : 0
        }
        headers: [
        ]
      }
      response: {
        body: {
          bytes: logHttpBodies ? 8192 : 0
        }
        headers: [
        ]
      }
    }
    httpCorrelationProtocol: 'W3C'
    logClientIp: true
    loggerId: apimApplicationInsightsLogger.id
    metrics: true
    operationNameFormat: 'Url'
    sampling: {
      percentage: 100
      samplingType: 'fixed'
    }
    verbosity: verbosity
  }
}
