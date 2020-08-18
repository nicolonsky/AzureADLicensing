# AzureADLicensing

PowerShell cmdlets to manage Azure AD group based licensing. Cmdlets use the internal Azure portal API which is not supported by Microsoft.

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/AzureADLicensing?label=PS%20Gallery%20Version&style=flat-square)](https://www.powershellgallery.com/packages/AzureADLicensing) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/AzureADLicensing?label=PS%20Gallery%20downloads&style=flat-square)](https://www.powershellgallery.com/packages/AzureADLicensing) ![GitHub](https://img.shields.io/github/license/nicolonsky/AzureADLicensing?style=flat-square)

## Using the module

1. Install the module: ```Install-Module -Name AzureADLicensing -AllowClobber```
    1. If you have the deprecated AzureRM module installed, uninstall it first ```Uninstall-AzureRm```
3. Authenticate to your Azure tenant: ```Connect-AzAccount```
    1. Feel free to use a service principal for unattended authentication and automation

## Available commands

All critical commands which modify settings support the `-WhatIf` parameter to predict changes.

Get available licenses and services:

```powershell
Get-AADLicenseSku
```

Get included service plans for a license:

```powershell
$m365= Get-AADLicenseSku | Where-Object {$_.name -match "Microsoft 365 E5"}
$m365.serviceStatuses.servicePlan
```

Add new license assignment:

```powershell
Add-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"
```

Add license assignmnet with disabled plan:

```powershell
Add-AADGroupLicenseAssignment -groupId 0a918505-d0d5-4078-9891-0e8bec67cb65 -accountSkuId "nicolasuter:SPE_E5" -disabledServicePlans @("MYANALYTICS_P2")
```

Update license assignment:

```powershell
Update-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"
```

Remove license assignment:

```powershell
Remove-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"
```

Get license assignments for a specific group:

```powershell
Get-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c"
```

Get all group based licensing assignments:

```powershell
Get-AADGroupLicenseAssignment -All
```
