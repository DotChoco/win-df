# Config file
$json = Get-Content -Path "$env:LOCALAPPDATA/Powershell/conf.json" -Raw | ConvertFrom-Json

# Global Mutables Variables
$HOMEDIR = $json.homedir
$DEVDIR = $json.devdir
$PWSDIR = $json.pwsdir
$VIDIR = $json.vidir


# Global Inmutables Variables
$DFDIR = "$DEVDIR/dot-files"
$CONTADIR = "$PWSDIR/Modules/fa"


# Imports
Import-Module core -Force
Import-Module styles -Force
Import-Module maths -Force
Import-Module fa -Force

Remove-Variable BasePath -ErrorAction SilentlyContinue

