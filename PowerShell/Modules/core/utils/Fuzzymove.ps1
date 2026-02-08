# Reemplazar el autocompletado de Tab con fzf para el comando 'z'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line -match '^\s*ff\s+(.*)$') {
        $partial = $matches[1]

        $result =  Get-ChildItem -Directory -Recurse -Depth 3 | Select-Object -ExpandProperty FullName | fzf `
            --height 40% `
            --reverse `
            --border rounded `
            --query "$partial" `
            --prompt "📁 " `
            --preview 'eza -la --no-permissions --no-time --no-filesize --color=always {}' `
            --preview-window=right:50% `

        if ($result) {
          $command = ""
          if ($result.Contains(" ")){ $command = "cd '$result'" }
          else{ $command = "cd $result" }
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $command)
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
        }
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext()
    }
}
