# Git
## Git Add
function gta {
  param([object[]]$files)
  if(!$files){ git add . }
  else{ git add @($files)}
}

##Git Diff
function gtd {
  param(
    [Parameter(Mandatory=$true)] # Makes the parameter required
    [string]$path
  )
  git diff $path
}

##Git Commit
function gtm {
  param([string]$comment)
  if($comment -eq ""){ $comment = "f: menor update" }
  gta && git commit -m $comment
}


##Git Log
function gtl {
  param([int]$index)
  if($index -eq 0){ git log }
  else { git log -$index }
}

##Fast Commit
function fcm {
  param([string]$comment)
  gta && gtm $comment && gtp
}

##Git Include
function gti {
  param([object[]]$files)
  git update-index --no-assume-unchange $files
}

##Git Exclude
function gte {
  param([object[]]$files)
  git update-index --assume-unchanged $files
}

##Git Restore
function gtr {
  param([object[]]$files)
  git restore $files
}

##Git Switch Branch
function gsb{
  param([string]$branch)
  git checkout $branch
}

function git_cmd{
  Write-Host "gta - Git Add(exmp: 'gta .' or 'gta' or 'gta ./src/main.c' )"
  Write-Host "gtm - Git Commit(exmp: 'gtm 'f: struct refactored'' or 'gtm' )"
  Write-Host "gsb - Git Switch Branch(exmp: 'gsb main' or 'gsb alpha')"
  Write-Host "gtr - Git Restore(exmp: 'gtr .' or 'gtr ./src/main.c' )"
  Write-Host "gte - Git Exclude(exmp: 'gte ./libs/' or 'gte ./src/main.c' )"
  Write-Host "gti - Git Include(exmp: 'gti ./libs/' or 'gti ./src/main.c' )"
  Write-Host "fcm - Fast Commit(exmp: 'fmc 'i: new repo'' or 'fmc' )"
  Write-Host "gtl - Git Log(exmp: 'gtl' or 'gtl 0' )"
  Write-Host "gtd - Git Diff(exmp: 'gtd ./src/main.c' )"
  Write-Host "glb - Git List Branches"
  Write-Host "gts - Git Status"
  Write-Host "gtp - Git Push"
  Write-Host "gtpl - Git Pull"
  Write-Host "gtcm - Git Commands"
  Write-Host "gtni - Git Init"
}


##Line Functions
function glb { git branch -a } ##Git List Branches
function gts { git status } ##Git Status
function gtp { git push } ##Git Push
function gtpl { git pull } ##Git Pull
function gtcm { git_cmd } ##Git Commands
function gtni { git init } ##Git Init


