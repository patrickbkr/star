param ([string]$RAKUDO_VER, [switch]$sign, [switch]$keep)

# inspired by https://github.com/hankache/rakudo-star-win/blob/master/build.ps1
# expected $RAKUDO_VER is something like "2021.03"
# if none is given, we will try to get the "latest" from gihub

IF ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot} ELSE { $ScriptRoot = Get-Location }
Write-Host "   INFO - `"`$ScriptRoot`" set to `"$ScriptRoot`""

IF ( -NOT ((Get-Command "cl.exe" -ErrorAction SilentlyContinue).Path) ) {
  Write-Host "WARNING - MSVC with `"cl.exe`", version 19 or newer, is a hard requirement to build NQP, Moar and Rakudo now, see"
  Write-Host "          https://github.com/rakudo/rakudo/commit/d01d4b26641bec2a62b43007b476f668982b9ab6#diff-a3c0a8904b9af2275c7ef3d4616ad9c3481898d3cc0e4698133948520b2df2ed"
  Write-Host "          https://github.com/Raku/nqp-configure/blob/e068508a94d643c1174bcd29e333dd659df502c5/lib/NQP/Config.pm#L252"
  
  IF ( -NOT ((Get-Command "Launch-VsDevShell.ps1" -ErrorAction SilentlyContinue).Path) ) {
    Write-Host "  ERROR - Couldn't neither find `"cl.exe`" nor `"Launch-VsDevShell.ps1`""
    Write-Host "  ERROR - Make sure `"Microsoft Visual C++ 2019`" or newer is installed and try again"
    EXIT
  } ELSE {
    Write-Host "   INFO - Executing `"Launch-VsDevShell.ps1`""
    & Launch-VsDevShell.ps1 2>&1 | Out-Null
  }
}

Write-Host "   INFO - Creating the .msi Package"
Write-Host "   INFO - .msi Package `"$msiBinFile`" created"

New-Item -Path . -Name "$msiBinFile" -ItemType "file" -Value "lala"

IF ( ! $keep ) {
  Write-Host "   INFO - Cleaning up..."
  Remove-Item files-*.wxs, *.wixobj, "Windows\rakudo-star-${RAKUDO_VER}-win-x86_64-msvc.wixpdb"
  Remove-Item -Recurse -Force "rakudo-${RAKUDO_VER}"
  #Remove-Item rakudo-$RAKUDO_VER\RAKUDO-${RAKUDO_VER}_build.log
  Remove-Item -Recurse -Force $PrefixPath
  Write-Host "   INFO - ALL done in dir `"", (pwd).Path, "`""
}

$Env:Path = $orgEnvPath
