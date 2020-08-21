# Create empty profile (so profile-integration scripts have something to append to)
if (!(Test-Path -Path $profile)) {
  Write-Host Adding profile file...
  New-Item -ItemType File -Path $profile -Force | Out-Null
}