# AzureADLicensing

PowerShell Cmdlets to manage Azure AD Group based Licensing.

[![PSGallery Version](https://img.shields.io/powershellgallery/v/AzureADLicensing.svg?style=flat-square&label=PSGallery%20Version)](https://www.powershellgallery.com/packages/AzureADLicensing) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/AzureADLicensing?style=flat-square&label=PSGallery%20Downloads)](https://www.powershellgallery.com/packages/AzureADLicensing)

## Using the module

1. Install the module: ```Install-Module -Name AzureADLicensing -AllowClobber```
2. If you hav the deprecated AzureRM module installed, uninstall it first ```Uninstall-AzureRm```
3. Authenticate to Azure: ```Get-AuthToken```

## Available commands

Get available licenses and services:

```Get-AADLicenseSku```

Get included service plans for a license:

<pre>
$m365= Get-AADLicenseSku | Where-Object {$_.name -match "Microsoft 365 E5"}
$m365.serviceStatuses.servicePlan
</pre>

Add new license assignment:

```Add-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"```

Add license assignmnet with disabled plan:

<pre>Add-AADGroupLicenseAssignment -groupId 0a918505-d0d5-4078-9891-0e8bec67cb65 -accountSkuId "nicolasuter:SPE_E5" -disabledServicePlans @("MYANALYTICS_P2")</pre>

Update license assignment:

<pre>Update-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"</pre>

Remove license assignment:

<pre>Remove-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"</pre>

Get license assignments:

```Get-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c"```
