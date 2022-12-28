param(				
    [Parameter(Mandatory=$True)]
    [String]
    $SqlResourceGroupName,

    [Parameter(Mandatory=$True)]
    [String]
    $SqlServerName,

    [Parameter(Mandatory=$True)]
    [String]
    $SqlServerFqdn,
    
    [Parameter(Mandatory=$True)]
    [String]
    $SqlDatabaseName,   
   
    [Parameter(Mandatory=$True)]
    [String]
    $PrincipalName,
    
    [Parameter(Mandatory=$True)]
    [String]
    $PrincipalId,

    [Parameter(Mandatory=$True)]
    [String]
    $DatabaseRoles    
)

$ErrorActionPreference = "Stop"
Install-Module SQLServer -Force

$ipAddress = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
$startIpAddress = $ipAddress.Substring(0, $ipAddress.LastIndexOf('.')) + ".0"
$endIpAddress = $ipAddress.Substring(0, $ipAddress.LastIndexOf('.')) + ".255"
$temporaryFirewallRuleName = 'temporary-firwall-rule-role-assignment'

New-AzSqlServerFirewallRule -FirewallRuleName $temporaryFirewallRuleName -ResourceGroupName $SqlResourceGroupName  -ServerName $SqlServerName -StartIpAddress $startIpAddress -EndIpAddress $endIpAddress

Write-Host "Created temporary SQL server firewall rule for $ipAddress"

$query = "
DECLARE @sid VARBINARY(85) = CONVERT(VARBINARY(85), CONVERT(UNIQUEIDENTIFIER, '$PrincipalId'))

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '$PrincipalName' AND sid = @sid)
    BEGIN
        PRINT 'User $PrincipalName does not exist with provided @sid'

        IF EXISTS (SELECT * FROM sys.database_principals WHERE name = '$PrincipalName')
        BEGIN
            PRINT 'User $PrincipalName exists with another sid, dropping current user'
            DROP USER [$PrincipalName]
        END

        DECLARE @sql NVARCHAR(1000) = CONCAT('CREATE USER [$PrincipalName] WITH sid = ', CONVERT(NVARCHAR(64), @sid,1), ', TYPE = E')
        EXEC (@sql)

        PRINT 'User $PrincipalName was created for $PrincipalId'
    END
"

foreach($DatabaseRole in $DatabaseRoles.Split('+'))
{
    $query = $query + "
    ALTER ROLE $DatabaseRole ADD MEMBER [$PrincipalName];"
}

$query = $query + "
    PRINT 'Assigned roles for user $PrincipalName'
";

$AccessToken = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
Write-Host $query
Write-Host $AccessToken
Write-Host "Start role assignment"
Invoke-Sqlcmd -ServerInstance $SqlServerFqdn -Database $SqlDatabaseName -AccessToken $AccessToken -Query $query  -OutputSqlErrors $true -AbortOnError -Verbose
Write-Host "Completed role assignment"

Remove-AzSqlServerFirewallRule -FirewallRuleName $temporaryFirewallRuleName -ResourceGroupName $SqlResourceGroupName  -ServerName $SqlServerName

Write-Host "Removed SQL server firewall rule for $ipAddress"