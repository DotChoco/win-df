param(
    [Parameter(Position = 0)]
    [string]$CommandName,

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$CommandArgs
)

Set-StrictMode -Version Latest

function Get-ClrFilePath {
    $path = Join-Path (Get-Location) 'commands.clr'

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "No se encontró 'commands.clr' en el directorio actual: $(Get-Location)"
    }

    return $path
}

function ConvertFrom-ClrCleanLine {
    param(
        [Parameter(Mandatory)]
        [string]$Line
    )

    $trimmed = $Line.Trim()

    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return $null
    }

    if ($trimmed -match '^\[([A-Za-z0-9_-]+)\]\s*(.+)$') {
        return [pscustomobject]@{
            Mode    = $Matches[1]
            Command = $Matches[2].Trim()
        }
    }

    return [pscustomobject]@{
        Mode    = $null
        Command = $trimmed
    }
}

function Get-ClrConfiguration {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $sections = [ordered]@{}
    $currentSection = $null
    $inCleanBlock = $false
    $lineNumber = 0

    foreach ($rawLine in Get-Content -LiteralPath $Path) {
        $lineNumber++
        $line = ($rawLine -replace "`t", '    ').TrimEnd()

        if ($line -match '^\s*$') {
            continue
        }

        if ($line -match '^\s*#') {
            continue
        }

        $indent = $line.Length - $line.TrimStart().Length
        $content = $line.TrimStart()

        if ($indent -eq 0) {
            if ($content -notmatch '^([A-Za-z0-9_-]+)\s*:\s*$') {
                throw "Sintaxis inválida en línea $($lineNumber): '$rawLine'"
            }

            $sectionName = $Matches[1]

            if ($sections.Contains($sectionName)) {
                throw "La sección '$sectionName' está repetida (línea $($lineNumber))."
            }

            $currentSection = [ordered]@{
                Name  = $sectionName
                Modes = @{}
                Clean = New-Object System.Collections.ArrayList
            }

            $sections[$sectionName] = $currentSection
            $inCleanBlock = $false
            continue
        }

        if ($null -eq $currentSection) {
            throw "Se encontró contenido fuera de una sección válida en la línea $($lineNumber)."
        }

        if ($indent -eq 2) {
            if ($content -notmatch '^([A-Za-z0-9_-]+)\s*:\s*(.*)$') {
                throw "Sintaxis inválida en línea $($lineNumber): '$rawLine'"
            }

            $key = $Matches[1]
            $value = $Matches[2].Trim()

            switch ($key) {
                'd' {
                    if ([string]::IsNullOrWhiteSpace($value)) {
                        throw "El comando 'd' de la sección '$($currentSection.Name)' no puede estar vacío (línea $($lineNumber))."
                    }

                    $currentSection.Modes['d'] = $value
                    $inCleanBlock = $false
                }

                'r' {
                    if ([string]::IsNullOrWhiteSpace($value)) {
                        throw "El comando 'r' de la sección '$($currentSection.Name)' no puede estar vacío (línea $($lineNumber))."
                    }

                    $currentSection.Modes['r'] = $value
                    $inCleanBlock = $false
                }

                'c' {
                    $inCleanBlock = $true

                    if (-not [string]::IsNullOrWhiteSpace($value)) {
                        $entry = ConvertFrom-ClrCleanLine -Line $value
                        if ($null -ne $entry) {
                            [void]$currentSection.Clean.Add($entry)
                        }
                    }
                }

                default {
                    throw "Clave no válida '$key' en la sección '$($currentSection.Name)' (línea $($lineNumber)). Solo se permiten: d, r, c."
                }
            }

            continue
        }

        if ($indent -ge 4) {
            if (-not $inCleanBlock) {
                throw "Indentación inválida en línea $($lineNumber). Solo se permiten líneas anidadas dentro de 'c:'."
            }

            $entry = ConvertFrom-ClrCleanLine -Line $content
            if ($null -ne $entry) {
                [void]$currentSection.Clean.Add($entry)
            }

            continue
        }

        throw "No se pudo interpretar la línea $($lineNumber): '$rawLine'"
    }

    return $sections
}

function Resolve-ClrOptions {
    param(
        [string[]]$Arguments
    )

    $result = [ordered]@{
        Clean = $false
        Mode  = $null
    }

    foreach ($arg in $Arguments) {
        if ($arg -notmatch '^-[A-Za-z]+$') {
            throw "Argumento inválido '$arg'. Usa combinaciones como: -c, -d, -r, -cd, -dc, -cr"
        }

        foreach ($flag in $arg.Substring(1).ToCharArray()) {
            switch ($flag) {
                'c' {
                    $result.Clean = $true
                }

                'd' {
                    if ($result.Mode -and $result.Mode -ne 'd') {
                        throw "No puedes usar debug y release al mismo tiempo."
                    }

                    $result.Mode = 'd'
                }

                'r' {
                    if ($result.Mode -and $result.Mode -ne 'r') {
                        throw "No puedes usar debug y release al mismo tiempo."
                    }

                    $result.Mode = 'r'
                }

                default {
                    throw "Flag desconocido '-$flag'. Solo se permiten: c, d, r"
                }
            }
        }
    }

    if (-not $result.Mode) {
        $result.Mode = 'd'
    }

    return $result
}

function Invoke-ClrTextCommand {
    param(
        [Parameter(Mandatory)]
        [string]$CommandText
    )

    if ([string]::IsNullOrWhiteSpace($CommandText)) {
        return
    }

    Write-Host ">> $CommandText" -ForegroundColor Cyan

    $global:LASTEXITCODE = 0
    Invoke-Expression $CommandText

    if (-not $?) {
        throw "Falló la ejecución del comando: $CommandText"
    }

    if ($global:LASTEXITCODE -ne 0) {
        throw "El comando terminó con código $($global:LASTEXITCODE): $CommandText"
    }
}

function Invoke-ClrNamedCommand {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('run', 'build')]
        [string]$Name,

        [string[]]$Arguments = @()
    )

    $path = Get-ClrFilePath
    $configuration = Get-ClrConfiguration -Path $path

    if (-not $configuration.Contains($Name)) {
        throw "El comando '$Name' no existe dentro de commands.clr"
    }

    $options = Resolve-ClrOptions -Arguments $Arguments
    $section = $configuration[$Name]
    $mode = $options.Mode

    if (-not $section.Modes.ContainsKey($mode)) {
        throw "El comando '$Name' no tiene variante '$mode' en commands.clr"
    }

    if ($options.Clean) {
        foreach ($entry in $section.Clean) {
            if ($null -eq $entry.Mode -or $entry.Mode -eq $mode) {
                Invoke-ClrTextCommand -CommandText $entry.Command
            }
        }
    }

    Invoke-ClrTextCommand -CommandText $section.Modes[$mode]
}

function Invoke-ClrRun {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    Invoke-ClrNamedCommand -Name 'run' -Arguments $Arguments
}

function Invoke-ClrBuild {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    Invoke-ClrNamedCommand -Name 'build' -Arguments $Arguments
}

# Exporta solo comandos públicos con verbos aprobados cuando esto viva dentro de un módulo.
if ($null -ne $ExecutionContext.SessionState.Module) {
    Export-ModuleMember -Function Invoke-ClrRun, Invoke-ClrBuild
}

# Permite ejecutar el archivo directamente como script:
#   .\compiler.ps1 run
#   .\compiler.ps1 run -c
#   .\compiler.ps1 build -cr
if (-not [string]::IsNullOrWhiteSpace($CommandName)) {
    switch ($CommandName) {
        'run' {
            Invoke-ClrRun -Arguments $CommandArgs
        }

        'build' {
            Invoke-ClrBuild -Arguments $CommandArgs
        }

        default {
            throw "Comando '$CommandName' no soportado. Solo se permiten: run, build"
        }
    }
}

function run   { Invoke-ClrRun @args }
function build { Invoke-ClrBuild @args }
