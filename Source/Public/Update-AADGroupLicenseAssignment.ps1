function Update-AADGroupLicenseAssignment {

    [cmdletbinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess($groupId, "Update license `"$accountSkuId`", disabled plans: `"$($disabledServicePlans -join `",`")`"")) {
            try {

                $response = Invoke-WebRequest -Method Post -Uri $($baseUrl + "AccountSkus/assign") -Headers $(Get-AuthToken) -Body $requestBody -ErrorAction Stop
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
}