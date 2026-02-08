function touch {
  param(
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [string]$dir_file,
    [string]$data
  )
  Write-Output($data) >> $dir_file
}


Set-Alias to touch
