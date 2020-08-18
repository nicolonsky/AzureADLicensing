@{
    Path = "AzureADLicensing.psd1"
    OutputDirectory = "..\bin\AzureADLicensing"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
