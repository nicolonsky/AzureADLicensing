function Get-AADLicenseSku {
    [cmdletbinding()]
    param()
    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {
            $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus") -Headers $global:header

            $requestContent = $request | ConvertFrom-Json

            return $requestContent
        }
        catch {
            if (($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details) {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details
            }
            else {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json)
            }
        }
    }
}

function Get-AADGroupLicenseAssignment {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [String]$groupId
    )

    process {

        $baseUrl = "https://main.iam.ad.ext.azure.com/api/"

        try {

            $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus/Group/$groupId") -Headers $global:header

            $requestContent = $request | ConvertFrom-Json

            return $requestContent

        }
        catch {
            if (($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details) {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details

            }
            else {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json)
            }
        }
    }
}

function Add-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [String]$groupId,
        [Parameter(Mandatory)]
        [String]$accountSkuId,
        [Parameter()]
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
            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $global:header -Body $requestBody

            $responseContent = $response | ConvertFrom-Json

            return $responseContent
        }
        catch {

            if (($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details) {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details
            }
            else {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json)
            }
        }
    }
}

function Update-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [String]$groupId,
        [Parameter(Mandatory)]
        [String]$accountSkuId,
        [Parameter()]
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
            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $global:header -Body $requestBody

            $responseContent = $response | ConvertFrom-Json

            return $responseContent
        }
        catch {

            if (($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details) {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details
            }
            else {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json)
            }
        }
    }
}
function Remove-AADGroupLicenseAssignment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [String]$groupId,
        [Parameter(Mandatory)]
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
            $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/remove") -Headers $global:header -Body $requestBody

            $responseContent = $response | ConvertFrom-Json

            return $responseContent
        }
        catch {

            if (($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details) {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Clientdata.operationresults.details
            }
            else {

                Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json)
            }
        }
    }
}
function Test-AzureRmToken {

    [CmdletBinding()]
    param()

    try{

        $context = Get-AzureRmContext
        $tenantId = $context.Tenant.Id
        $refreshToken = @($context.TokenCache.ReadItems() | Where-Object { $_.tenantId -eq $tenantId -and $_.ExpiresOn -gt (Get-Date) })[0].RefreshToken
        
        if ($refreshToken){
            return $refreshToken
        }

    }catch{}
}
function Get-AzureRmToken {

    # Derrived from Jos Lieben https://gitlab.com/Lieben/assortedFunctions/blob/master/get-azureRMtoken.ps1

    [Cmdletbinding()]
    param()

    process {

        try {

            $refreshToken = Test-AzureRmToken
            $context = Get-AzureRmContext
            $tenantId = $context.Tenant.Id

            if ([string]::IsNullOrEmpty($refreshToken)){
                Login-AzureRmAccount
                $refreshToken = Test-AzureRmToken
            }

            $body = "grant_type=refresh_token&refresh_token=$($refreshToken)&resource=74658136-14ec-4630-ad9b-26e160ff0fc6"

            $apiToken = Invoke-RestMethod "https://login.windows.net/$tenantId/oauth2/token" -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'

            $global:header = @{
                'Authorization'          = 'Bearer ' + $apiToken.access_token
                'Content-Type'           = 'application/json'
                'X-Requested-With'       = 'XMLHttpRequest'
                'x-ms-client-request-id' = [guid]::NewGuid()
                'x-ms-correlation-id'    = [guid]::NewGuid()
            }

            return $true

        }
        catch {

            Write-Error $_
        }
    }
}