param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file real-estate-sales-api.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "apim_real-estate-sales-api_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"