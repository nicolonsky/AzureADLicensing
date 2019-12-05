# AzureADLicensing

PowerShell Cmdlets to manage Azure AD Group based Licensing.

[![PSGallery Version](https://img.shields.io/powershellgallery/v/AzureADLicensing.svg?style=flat-square&label=PSGallery%20Version)](https://www.powershellgallery.com/packages/AzureADLicensing) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/AzureADLicensing?style=flat-square&label=PSGallery%20Downloads)](https://www.powershellgallery.com/packages/AzureADLicensing)

## Using the module

1. ```Install-Module -Name AzureADLicensing, AzureRm```
2. ```Get-AzureRmToken```

## Available commands

Get available licenses and services:

```Get-AADLicenseSku```

Get included service plans for a license:

```$m365= Get-AADLicenseSku | Where-Object {$_.name -match "Microsoft 365 E5"}
$m365.serviceStatuses.servicePlan```


Add new license assignment:

```Add-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"```

Add license assignmnet with disabled plan:

```Add-AADGroupLicenseAssignment -groupId 0a918505-d0d5-4078-9891-0e8bec67cb65 -accountSkuId "nicolasuter:SPE_E5" -disabledServicePlans @("MYANALYTICS_P2")```

Update license assignment:

```Update-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"```

Remove license assignment:

```Remove-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"```

Get license assignments:

```Get-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c"```

Clear AzureRm context:

```Set-AzureRmContext -Context ([Microsoft.Azure.Commands.Profile.Models.PSAzureContext]::new())```
