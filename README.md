# AzureADLicensing

PowerShell Cmdlets to manage Azure AD Group based Licensing.

[![PSGallery Version](https://img.shields.io/powershellgallery/v/AzureADLicensing.svg?style=flat-square&label=PSGallery%20Version)](https://www.powershellgallery.com/packages/AzureADLicensing) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/AzureADLicensing?style=flat-square&label=PSGallery%20Downloads)](https://www.powershellgallery.com/packages/AzureADLicensing)

## Using the module

1. Install-Module -Name AzureADLicensing, AzureRm
2. Get-AzureRmToken

## Available commands

Get available licenses:
<pre>Get-AADLicenseSku</pre>

Add new license assignment:
<pre>Add-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"</pre>

Update license assignment:
<pre>Update-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"</pre>

Remove license assignment:
<pre>Remove-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c" -accountSkuId "nicolasuter:FLOW_FREE"</pre>

Get license assignments:
<pre>Get-AADGroupLicenseAssignment -groupId "a5e95316-1c03-44d7-afac-efd0e788122c"</pre>

Clear AzureRm context:
<pre> Set-AzureRmContext -Context ([Microsoft.Azure.Commands.Profile.Models.PSAzureContext]::new()) </pre>
