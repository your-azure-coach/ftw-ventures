// Scope
targetScope = 'resourceGroup'

// Parameters
param storageAccountName string
param blobContainerName string
param blobName string
param blobBase64Content string
param scriptIdentityId string
param scriptIdentityPrincipalId string
param scriptResourceGroupName string
param location string
param deploymentId string

// Grant access to upload blobs (needed for the database script)
module blobStorageRoleAssignment 'role-assignment-storage-account.bicep' = {
  name: 'ra-st-${take(guid(storageAccountName, scriptIdentityPrincipalId), 44)}-${deploymentId}'
  params: {
    principalId: scriptIdentityPrincipalId
    principalType: 'ServicePrincipal'
    roleName: 'Storage Blob Data Contributor'
    storageAccountName: storageAccountName
  }
}

// Call script
module removeApiManagementDefault 'deployment-script.bicep' = {
  name: 'upload-blob-${take('${blobName}-${blobContainerName}', 40)}-${deploymentId}'
  scope: az.resourceGroup(scriptResourceGroupName)
  params: {
    name: 'deploy-upload-blob-${guid(blobName, blobContainerName,deploymentId)}'
    location: location
    deploymentIdentityId: scriptIdentityId
    scriptContent: loadTextContent('scripts/storage-account-upload-blob.ps1')
    scriptArguments: '-StorageAccountName ${storageAccountName} -BlobContainerName ${blobContainerName} -BlobName ${blobName} -BlobBase64Content ${blobBase64Content}'
    deploymentId: deploymentId
  }
  dependsOn: [ blobStorageRoleAssignment ]
}
