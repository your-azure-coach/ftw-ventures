param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file shared-infra.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "shared-infra_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"