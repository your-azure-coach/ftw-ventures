param(				
    [Parameter(Mandatory=$True)]
    [String]
    $StorageAccountName,

    [Parameter(Mandatory=$True)]
    [String]
    $BlobContainerName,

    [Parameter(Mandatory=$True)]
    [String]
    $BlobName,

    [Parameter(Mandatory=$True)]
    [String]
    $BlobBase64Content
)

$ErrorActionPreference = "Stop"

$BlobFile = New-TemporaryFile
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($BlobBase64Content)) | Out-File -FilePath $blobFile

$StorageAccountContext = New-AzStorageContext -StorageAccountName $StorageAccountName
Set-AzStorageBlobContent -File $BlobFile -Container $BlobContainerName -Context $StorageAccountContext -blob $BlobName -Force

$DeploymentScriptResult = @{}
$DeploymentScriptResult['success'] = $true

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['result'] =  $DeploymentScriptResult