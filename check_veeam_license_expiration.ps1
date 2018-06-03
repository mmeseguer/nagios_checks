<#
.SYNOPSIS
    Name: check_veeam_license_expiration.ps1
    Script to check the license expiration date of Veeam Backup and Replication via Nagios.
.DESCRIPTION
    Simple Nagios check to monitor the expiration date of Veeam Backup and Replication.
.PARAMETER Warn
    Threshold for the warning state.
.PARAMETER Crit
    Threshold for the critical state.
.EXAMPLE
    check_veeam_license_expiration.ps1 -w 5 -c 2
    Basic use example.
    
.NOTES
    Name: check_veeam_license_expiration
    Author: Marc Meseguer (https://sobrebits.com)
    Last Edit: 02/05/2018 [1.0]
    Version 1.0
        - First release
#>

#### Parameters ####
Param(
    [Alias('W')]
    [int]$warn = 7,
    [Alias('C')]
    [int]$crit = 2
)

#### Variables ####
# Defining the expiration pattern (found here: https://ict-freak.nl/2011/12/29/powershell-veeam-br-get-total-days-before-the-license-expires/)
$pattern_date = "Expiration date\=\d{1,2}\/\d{1,2}\/\d{1,4}"

#### Body ####
# We obtain the license information consulting it's registry key.
# Getting registry key information.
$regkey_veeam = (Get-Item 'HKLM:\SOFTWARE\VeeaM\Veeam Backup and Replication\license').GetValue('Lic1')
# Converting registry key into human readable content.
$lic_veeam = [string]::Join($null, ($regkey_veeam | ForEach-Object { [char][int]$_;}))

# Extracting the expiration date using the previously defined $pattern_date.
$expdate_veeam = [regex]::matches($lic_veeam,$pattern_date)[0].Value.Split("=")[1]
# Getting the days until today.
$licdays_veeam = [int](((Get-Date $expdate_veeam) - (Get-Date)).TotalDays.toString().split(",")[0])

# Generating monitoring output.
If ($licdays_veeam -gt $warn) {
    Write-Host "OK! $licdays_veeam days left for VBR's license to expire."
    Exit 0
}
ElseIf ($licdays_veeam -gt $crit) {
    Write-Host "WARNING! $licdays_veeam days left for VBR's license to expire."
    Exit 1
}
Else {
    Write-Host "CRITICAL! $licdays_veeam days left for VBR's license to expire."
    Exit 2
}