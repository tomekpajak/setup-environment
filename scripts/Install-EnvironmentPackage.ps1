param(
    [string] $script,
    [string] $packageName
)
# Refresh environmnet variable
if (!($Env:PSModulePath.Contains("C:\ProgramData\Boxstarter"))) 
{
    $Env:PSModulePath += ";C:\ProgramData\Boxstarter"
}
. $profile
RefreshEnv

# Prepare environment package for Boxstarter
Write-Host "Preparing environment package $packageName..."
Import-Module Boxstarter.Chocolatey
New-PackageFromScript -Source $script -PackageName $packageName

# Installing environment package
Write-Host "Instaling environment package $packageName..."
Install-BoxstarterPackage -Package $packageName