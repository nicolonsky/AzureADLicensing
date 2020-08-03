# AzureADLicensing

PowerShell cmdlets to manage Azure AD group based licensing. Cmdlets use the internal Azure portal API which is not supported by Microsoft.

[![PSGallery Version](https://img.shields.io/powershellgallery/v/AzureADLicensing.svg?style=flat-square&label=PSGallery%20Version)](https://www.powershellgallery.com/packages/AzureADLicensing) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/AzureADLicensing?style=flat-square&label=PSGallery%20Downloads)](https://www.powershellgallery.com/packages/AzureADLicensing)

## Using the module

1. Install the module: ```Install-Module -Name AzureADLicensing -AllowClobber```
2. Authenticate to Azure: ```Connect-AzAccount```

## Available commands

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
