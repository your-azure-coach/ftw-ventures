param(				
    [Parameter(Mandatory=$True)]
    [String]
    $ApiManagementName,

    [Parameter(Mandatory=$True)]
    [String]
    $ResourceGroupName
)

$ErrorActionPreference = "Stop"
$apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $ApiManagementName

try { 
    Get-AzApiManagementApi -Context $apimContext -ApiId 'echo-api' 
    Remove-AzApiManagementApi -Context $apimContext -ApiId 'echo-api' 
}
catch {}

try {
    Get-AzApiManagementProduct -Context $apimContext -ProductId 'starter' 
    Remove-AzApiManagementProduct -Context $apimContext -ProductId 'starter' -DeleteSubscriptions
}
catch {}

try {
    Get-AzApiManagementProduct -Context $apimContext -ProductId 'unlimited' 
    Remove-AzApiManagementProduct -Context $apimContext -ProductId 'unlimited' -DeleteSubscriptions
}
catch {}

$DeploymentScriptResult = @{}
$DeploymentScriptResult['success'] = $true

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['result'] =  $DeploymentScriptResult