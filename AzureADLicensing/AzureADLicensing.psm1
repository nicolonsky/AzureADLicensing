function Get-AADLicenseSku {
    [cmdletbinding()]
    param()

    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {
            $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus") -Headers $(Get-AuthToken)
            $requestContent = $request | ConvertFrom-Json
            return $requestContent
        }
        catch {
            # convert the error message if it appears to be JSON
            if ($_.ErrorDetails.Message -like "{`"Classname*") {
                $local:errmsg = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($local:errmsg.Clientdata.operationresults.details) {
                    Write-Error $local:errmsg.Clientdata.operationresults.details
                }
                else {
                    Write-Error $local:errmsg
                }
            }
            else {
                Write-Error $_
            }
        }
    }
}          

function Get-AADGroupLicenseAssignment {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group", ParameterSetName = "Single")]
        [guid]$groupId,

        [Parameter(Mandatory, HelpMessage = "Retrieves all Group Based License Assignments", ParameterSetName = "All")]
        [switch]
        $All
    )
    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {

            if ($All.IsPresent) {

                $accountSkus = Get-AADLicenseSku
                $rep = @()

                foreach ($sku in $accountSkus){
                    $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus/GroupAssignments?accountSkuID=$($sku.accountSkuId)&nextLink=&searchText=&sortOrder=undefined") -Headers $(Get-AuthToken)
                    $requestContent = $request | ConvertFrom-Json

                    $licensedGroups = $requestContent.items | Select-Object objectId, displayName

                    $rep += [PSCustomObject]@{
                        Name = $sku.Name
                        AccountSkuId = $sku.accountSkuId
                        LicensedGroups = $licensedGroups
                    }
                }

                return $rep
                
            }else {
                $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus/Group/$groupId") -Headers $(Get-AuthToken)
                $requestContent = $request | ConvertFrom-Json
                return $requestContent
            }
        }
        catch {
            # convert the error message if it appears to be JSON
            if ($_.ErrorDetails.Message -like "{`"Classname*") {
                $local:errmsg = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($local:errmsg.Clientdata.operationresults.details) {
                    Write-Error $local:errmsg.Clientdata.operationresults.details
                }
                else {
                    Write-Error $local:errmsg
                }
            }
            else {
                Write-Error $_
            }
        }
    }
}

function Add-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [guid]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to assign")]
        [String]$accountSkuId,
        [Parameter(HelpMessage = "Excluded features for the specified SKU")]
        [String[]]$disabledServicePlans = @()
    )
    process {

        $licenceAssignmentConfig = @{
            assignments = @(
                @{
                    "objectId"       = "$groupId"
                    "isUser"         = $false
                    "addLicenses"    = @(
                        @{
                            "accountSkuId"         = "$accountSkuId"
                            "disabledServicePlans" = @($disabledServicePlans)
                        }
                    )
                    "removeLicenses" = @()
                    "updateLicenses" = @()
                }
            )
        }

        $requestBody = $licenceAssignmentConfig | ConvertTo-Json -Depth 5
        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {
            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $(Get-AuthToken) -Body $requestBody

            $responseContent = $response | ConvertFrom-Json

            return $responseContent
        }
        catch {
            # convert the error message if it appears to be JSON
            if ($_.ErrorDetails.Message -like "{`"Classname*") {
                $local:errmsg = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($local:errmsg.Clientdata.operationresults.details) {
                    Write-Error $local:errmsg.Clientdata.operationresults.details
                }
                else {
                    Write-Error $local:errmsg
                }
            }
            else {
                Write-Error $_
            }
        }
    }
}

function Update-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [guid]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to assign")]
        [String]$accountSkuId,
        [Parameter(HelpMessage = "Excluded features for the specified SKU")]
        [String[]]$disabledServicePlans = @()
    )
    process {

        $licenceAssignmentConfig = @{
            assignments = @(
                @{
                    "objectId"       = "$groupId"
                    "isUser"         = $false
                    "addLicenses"    = @()
                    "removeLicenses" = @()
                    "updateLicenses" = @(
                        @{
                            "accountSkuId"         = "$accountSkuId"
                            "disabledServicePlans" = @($disabledServicePlans)
                        }
                    )
                }
            )
        }

        $requestBody = $licenceAssignmentConfig | ConvertTo-Json -Depth 5
        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {

            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $(Get-AuthToken) -Body $requestBody
            $responseContent = $response | ConvertFrom-Json
            return $responseContent
        }
        catch {
            # convert the error message if it appears to be JSON
            if ($_.ErrorDetails.Message -like "{`"Classname*") {
                $local:errmsg = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($local:errmsg.Clientdata.operationresults.details) {
                    Write-Error $local:errmsg.Clientdata.operationresults.details
                }
                else {
                    Write-Error $local:errmsg
                }
            }
            else {
                Write-Error $_
            }
        }
    }
}
function Remove-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [guid]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to remove")]
        [String]$accountSkuId
    )
    process {

        $licenceAssignmentConfig = @{
            assignments = @(
                @{
                    "objectId"       = "$groupId"
                    "isUser"         = $false
                    "addLicenses"    = @()
                    "removeLicenses" = @($accountSkuId)
                    "updateLicenses" = @()
                }
            )
        }

        $requestBody = $licenceAssignmentConfig | ConvertTo-Json -Depth 5
        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {

            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/remove") -Headers $(Get-AuthToken) -Body $requestBody
            $responseContent = $response | ConvertFrom-Json
            return $responseContent

        }
        catch {
            # convert the error message if it appears to be JSON
            if ($_.ErrorDetails.Message -like "{`"Classname*") {
                $local:errmsg = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($local:errmsg.Clientdata.operationresults.details) {
                    Write-Error $local:errmsg.Clientdata.operationresults.details
                }
                else {
                    Write-Error $local:errmsg
                }
            }
            else {
                Write-Error $_
            }
        }
    }
}
function Get-AuthToken {

    [Cmdletbinding()]
    param()
    
    process {    

        $context = Get-AzContext

        if ($null -eq $context) {
            $null = Connect-AZAccount -EA stop
            $context = Get-AzContext  
        }

        $apiToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id, $null, "Never", $null, "74658136-14ec-4630-ad9b-26e160ff0fc6")

        $header = @{
            'Authorization'          = 'Bearer ' + $apiToken.AccessToken.ToString()
            'Content-Type'           = 'application/json'
            'X-Requested-With'       = 'XMLHttpRequest'
            'x-ms-client-request-id' = [guid]::NewGuid()
            'x-ms-correlation-id'    = [guid]::NewGuid()
        }

        Write-Verbose "Connected to tenant: '$($context.Tenant.Id)' as: '$($context.Account)'"

        return $header
    }
}