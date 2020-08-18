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