# Contability/Contability.psm1

# Private Variable (doesn't export)
$BasePath = Join-Path $PSScriptRoot 'utils'

# Dot‑source all in "utils"
Get-ChildItem -Path $BasePath -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}

# Export ALL (You can filter from Function, Alias, Variable, Cmdlet)
Export-ModuleMember -Function * -Alias * -Variable *

