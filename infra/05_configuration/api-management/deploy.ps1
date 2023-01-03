param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file api-management.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "apim_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"