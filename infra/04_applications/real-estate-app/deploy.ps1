param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file real-estate-app.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "real-estate-app-$((Get-Date).ToString("yyyyMMdd_HHmmss"))"