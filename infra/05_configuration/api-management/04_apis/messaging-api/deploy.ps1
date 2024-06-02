param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file messaging-api.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "messaging-api_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"