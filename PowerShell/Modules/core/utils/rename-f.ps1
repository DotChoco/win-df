function Rename-BatchFiles {
  param(
    [string]$FolderPath = (Get-Location).Path,
    [string]$Pattern = "pl_{0}.xml",
    [string]$FileFilter = "*.xml",
    [int]$StartIndex = 1,
    [switch]$Preview
  )

  $files = Get-ChildItem -Path $FolderPath -Filter $FileFilter | Sort-Object Name
  $index = $StartIndex

  foreach ($file in $files) {
    $newName = $Pattern -f $index
    $newPath = Join-Path -Path $FolderPath -ChildPath $newName

    if ($Preview) {
      Write-Host "[Preview] $($file.Name) => $newName"
    }
    else {
      Rename-Item -Path $file.FullName -NewName $newName
    }

    $index++
  }
}


Set-Alias rbf Rename-BatchFiles
