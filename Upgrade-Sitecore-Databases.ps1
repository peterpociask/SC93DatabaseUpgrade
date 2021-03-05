Param(
    [string]$SettingsPath = "$PSScriptRoot\Settings.ps1",
    [string]$UserSettingsPath = "$PSScriptRoot\Settings.User.ps1",
    [string]$SitecoreBaseVersion = "",
    [HashTable]$CustomSettings = @{}
)

$ErrorActionPreference = 'Inquire'

Import-Module sqlserver

. $PSScriptRoot\Tasks.ps1
$Settings = Invoke-GetSettings -SettingsPath $SettingsPath -UserSettingsPath $UserSettingsPath -CustomSettings $CustomSettings

# Code from https://www.mssqltips.com/sqlservertip/4224/getting-started-querying-your-azure-sql-database-in-powershell/
# Run this to add a firewall rule allowing you to connect from your local machine
# Add-AzureAccount
# Get-AzureSqlDatabaseServer
# $ipAddress = (Invoke-WebRequest 'http://myexternalip.com/raw').Content -replace "`n"
# New-AzureSqlDatabaseServerFirewallRule -ServerName $serverName -RuleName '93UpgradeClientRule' -StartIpAddress $ipAddress -EndIpAddress $ipAddress

# Run the CMS_core_master_web9x.sql script for the Core, Master, and Web databases.
$params = @{
    'Database'        = $Settings.MasterDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\CMS_core_master_web_9x.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

$params = @{
    'Database'        = $Settings.CoreDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\CMS_core_master_web_9x.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

$params = @{
    'Database'        = $Settings.WebDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\CMS_core_master_web_9x.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the CMS_core.sql script for the Core database
$params = @{
    'Database'        = $Settings.CoreDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\CMS_core.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_processing_tasks.sql script for the Processing.tasks database.
$params = @{
    'Database'        = $Settings.ProcessingTasksDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_processing_tasks.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_experienceforms_storage.sql for the ExperienceForms database.
$params = @{
    'Database'        = $Settings.ExperienceFormsDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_experienceforms_storage.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_experienceforms_filestorage.sql for the ExperienceForms database.
$params = @{
    'Database'        = $Settings.ExperienceFormsDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_experienceforms_filestorage.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_reporting.sql script for the Reporting database.
$params = @{
    'Database'        = $Settings.ReportingDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_reporting.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_reporting_migrate_experience_optimization_data.sql for the Reporting database.
$params = @{
    'Database'        = $Settings.ReportingDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_reporting_migrate_experience_optimization_data.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}


# If you are upgrading from Sitecore XP 9.0.1, you must upgrade the Messaging database.
# To upgrade the Messaging database, run the SXP_Messaging.sql script
$params = @{
    'Database'        = $Settings.MessagingDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_Messaging.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Upgrade the xDB Reference Data database
# definitions cannot be migrated. Length of # definition monikers exceeds 300 characters. Consider truncate, change or remove them. Upgrade stopped. Fix all the issues and run this script again. Upgrade (part 1) has not been completed.
# Fix all the issues as described in this message and run the SXP_referencedata_Part1.sql script again.
# Repeat this step until you receive the “definitions cannot be migrated” message.

$params = @{
    'Database'        = $Settings.ReferenceDataDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_referencedata_Part1.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

$params = @{
    'Database'        = $Settings.ReferenceDataDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_referencedata_Part2.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}


# Upgrade ShardMapManagerDatabase
$params = @{
    'Database'        = $Settings.ReferenceDataDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_collection_smm.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}


# XDB collection upgrade?

# Run the SXP_processing_pools.sql script for the Xdb Processing Pools database.
$params = @{
    'Database'        = $Settings.ProcessingPoolsDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_processing_pools.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}

# Run the SXP_marketingautomation.sql script for the Xdb Marketing Automation database.
$params = @{
    'Database'        = $Settings.MarketingAutomationDatabase
    'ServerInstance'  = $Settings.ServerInstance
    'Username'        = $Settings.UserName
    'Password'        = $Settings.Password
    'OutputSqlErrors' = $true
    'Query'           = Get-Content -Raw -Path .\Scripts\SXP_marketingautomation.sql
}
try {
   Invoke-Sqlcmd @params
} catch {
  "error when running sql:"
  Write-Host($_.Exception.Message)
}