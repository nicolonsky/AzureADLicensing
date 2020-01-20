function Get-AADLicenseSku {
    [cmdletbinding()]
    param()
    begin{
        Test-AuthToken
    }
    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {
            $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus") -Headers $global:header

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
                Write-Error $_.ErrorDetails.Message
            }
        }
    }
}

function Get-AADGroupLicenseAssignment {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [String]$groupId
    )
    begin{
        Test-AuthToken
    }
    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {

            $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus/Group/$groupId") -Headers $global:header

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
                Write-Error $_.ErrorDetails.Message
            }
        }
    }
}

function Add-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [String]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to assign")]
        [String]$accountSkuId,
        [Parameter(HelpMessage = "Excluded features for the specified SKU")]
        [String[]]$disabledServicePlans = @()
    )
    begin{
        Test-AuthToken
    }
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
            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $global:header -Body $requestBody

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
                Write-Error $_.ErrorDetails.Message
            }
        }
    }
}

function Update-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [String]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to assign")]
        [String]$accountSkuId,
        [Parameter(HelpMessage = "Excluded features for the specified SKU")]
        [String[]]$disabledServicePlans = @()
    )
    begin{
        Test-AuthToken
    }
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

            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $global:header -Body $requestBody
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
                Write-Error $_.ErrorDetails.Message
            }
        }
    }
}
function Remove-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "ID of the Azure AD group")]
        [String]$groupId,
        [Parameter(Mandatory, HelpMessage = "License SKU to remove")]
        [String]$accountSkuId
    )
    begin{
        Test-AuthToken
    }
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

            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/remove") -Headers $global:header -Body $requestBody
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
                Write-Error $_.ErrorDetails.Message
            }
        }
    }
}
function Get-AuthToken {

    [Cmdletbinding()]
    param()
    
    process {

        try {

            $context = (Get-AzContext -ErrorAction SilentlyContinue | Select-Object -First 1)

            if ([string]::IsNullOrEmpty($context)) {
                $null = Connect-AZAccount
                $context = (Get-AzContext | Select-Object -First 1)
            }

            $apiToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id, $null, "Never", $null, "74658136-14ec-4630-ad9b-26e160ff0fc6")

            Write-Output "Connected to tenant: '$($context.Tenant.Id)' as: '$($context.Account)'"
            $global:header = @{
                'Authorization'          = 'Bearer ' + $apiToken.AccessToken.ToString()
                'Content-Type'           = 'application/json'
                'X-Requested-With'       = 'XMLHttpRequest'
                'x-ms-client-request-id' = [guid]::NewGuid()
                'x-ms-correlation-id'    = [guid]::NewGuid()
            }
        }
        catch {

            Write-Error $_
        }
    }
}
function Test-AuthToken {

    [Cmdletbinding()]
    param()
    
    process {

        $context = (Get-AzContext -ErrorAction SilentlyContinue | Select-Object -First 1)

        if ([string]::IsNullOrEmpty($context) -or $null -eq $global:header) {

            Throw "Not authenticated.  Please use the `"Get-AuthToken`" command to authenticate."
        }else{
            Write-Verbose "Connected to tenant: '$($context.Tenant.Id)' as: '$($context.Account)'"
        }
    }
}
