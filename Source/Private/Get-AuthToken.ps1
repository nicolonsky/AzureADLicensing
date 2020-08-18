function Get-AuthToken {
    [Cmdletbinding()]
    [OutputType([hashtable])]

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