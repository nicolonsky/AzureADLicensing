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
                $request = Invoke-WebRequest -Method Get -Uri $($baseUrl + "AccountSkus/Group/$groupId") -Headers $(Get-AuthToken) -ErrorAction Stop
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