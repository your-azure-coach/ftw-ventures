// Scope
targetScope = 'resourceGroup'

// Parameters
param apimName string 
param logicAppName string
param storageAccountName string
param blobContainerName string
param location string
param deploymentId string

var resourceManagerUrl = az.environment().resourceManager

//Reference existing resources
resource apiManagement 'Microsoft.ApiManagement/service@2022-04-01-preview' existing = {
  name: apimName
}

//Describe Logic App that performs the nightly backup
resource backupLogicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {
    parameters: {
      backup_container_name: {
        value: blobContainerName
      }
      apim_id: {
        value: apiManagement.id
      }
      storage_account_name: {
        value: storageAccountName
      }
      resource_manager_url: {
        value: resourceManagerUrl
      }
    }
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        backup_container_name: {
          type: 'String'
        }
        apim_id: {
          type: 'String'
        }
        storage_account_name: {
          type: 'String'
        }
        resource_manager_url: {
          type: 'String'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {
              hours: [
                1
              ]
              minutes: [
                0
              ]
            }
            timeZone: 'W. Europe Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Perform_API_Management_Backup: {
          runAfter: {
          }
          type: 'Http'
          inputs: {
            authentication: {
              audience: '@{parameters(\'resource_manager_url\')}'
              type: 'ManagedServiceIdentity'
            }
            body: {
              backupName: '@{concat(\'apim-\', string(utcNow(\'yyyyMMdd\')))}'
              containerName: '@{parameters(\'backup_container_name\')}'
              storageAccount: '@{parameters(\'storage_account_name\')}'
              accessType: 'SystemAssignedManagedIdentity'
            }
            method: 'POST'
            uri: '@{concat(parameters(\'resource_manager_url\'), parameters(\'apim_id\'))}/backup?api-version=2021-08-01'
          }
        }
      }
      outputs: {
      }
    }
  }
}

//Grant Logic App access to call the Backup API
module backupApimRoleAssignment 'role-assignment-api-management.bicep' = {
  scope: az.resourceGroup()
  name: 'ra-apim-${take(logicAppName, 42)}-${deploymentId}'
  params: {
    roleName: 'API Management Service Operator Role'
    principalId: backupLogicApp.identity.principalId
    principalType: 'ServicePrincipal'
    apiManagementName: apiManagement.name
  }
}

//Grant API Management access to Blob Storage
module backupStorageRoleAssignment 'role-assignment-storage-account.bicep' = {
  scope: az.resourceGroup()
  name: 'ra-storage-${take(logicAppName, 39)}-${deploymentId}'
  params: {
    principalId: apiManagement.identity.principalId
    principalType: 'ServicePrincipal'
    roleName: 'Storage Blob Data Contributor'
    storageAccountName: storageAccountName
  }
}
