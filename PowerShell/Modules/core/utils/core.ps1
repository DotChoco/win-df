# Suggestions
# Set-PSReadlineOption -PredictionViewStyle ListView

## Dirs
function jj { cd "$HOMEDIR"} # home dir
function gg { cd $DEVDIR } # dev dir
function psd { cd $PWSDIR } #Go to the PowerShell Path
function df { cd $DFDIR }
function nvc { cd $VIDIR } #Go to the Nvim Path
function ~ { jj }
function .. { cd .. } #Make a backward move

function ee { exit } #Close the terminal
function dd { shutdown /s /t 0 } #Shutdown the PC


## Custom Behaviours
function ex {
  param([string]$Path)
  if($Path -eq ""){$Path = Get-Location}
  explorer $Path
} #Open File Explorer

### Copy to Clipboard
function cb {
  param (
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [string]$FilePath            # Parameter of type string
  )
  cat $FilePath | scb
}

### Check if the path exists
function Test-PathExists {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path # Parameter of type string
  )

  if (Test-Path -Path $Path) { return $true}
  else { return $false }
}

### Remove recursive an item forcefully
function Remove-ItemForcefully{
  param (
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [object[]]$files             # Parameter of type string
  )
  rm $files -Force -Recurse
}

### Copy recursive an item forcefully
function Copy-ItemForcefully{
  param (
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [object[]]$files,             # Parameter of type string
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [string]$destiny             # Parameter of type string
  )
  cp $files $destiny -Force -Recurse
}


### Copy recursive an item forcefully
function mk{
  param (
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [object[]]$Files,             # Parameter of type string
    [string]$Destiny             # Parameter of type string
  )
  if($Destiny -eq ""){ $Destiny = Get-Location }
  mkdir $Files | Out-Null
}




# Alias
Set-Alias unzip Expand-Archive
# Set-Alias mk mkdir
Set-Alias zip Compress-Archive
Set-Alias cls clear
Set-Alias cc clear
Set-Alias xx ex
Set-Alias fr Remove-ItemForcefully
Set-Alias ffc Copy-ItemForcefully


