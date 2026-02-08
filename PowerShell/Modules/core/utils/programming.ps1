#CPP
## Cmake
function cmm {
  $dir_build= (Get-Location).Path + "\build\"
  $exist_dir = Test-PathExists $dir_build

  if($exist_dir -eq $true){ rm $dir_build -Force -Recurse }

  mkdir $dir_build
  cd build/

  cmake .. -G "Ninja"
  cmake --build .

  cd ../
}

## CPP Run
function cr {
  param (
    [string]$path,
    [string]$name
  )
  if($path -eq ""){ $path = Get-Location }
  if($name -eq ""){ $name = "DebugApp.exe" }
  g++.exe -o $path $name
}

## CPP Build
function crb {
  param (
    [string]$OutputName = "program",
    [string]$ProjectRoot = "."
  )
  if($ProjectRoot -eq ""){ $ProjectRoot = (Get-Location).Path + "\src\main.cpp" }
  if($OutputName -eq ""){ $OutputName = "DebugApp.exe" }
  g++.exe -o $OutputName $ProjectRoot\src\main.cpp
}



# Go
# Go Run
function gor {
  param (
    [string]$path
  )
  if($ProjectRoot -eq ""){ $ProjectRoot = (Get-Location).Path + "\main.go" }
  go.exe run $path
}


## Dotnet
function dnbr { dotnet build -c Release }
function dnb { dotnet build }
function dnr { dotnet run }
function dnrr { dotnet run --configuration Release }


## PHP
function plh {
  param (
    [int]$port
  )
  php -S localhost:$port
}

#Apache Server
#Stop
function assp { httpd -k stop }
#Start
function asst { httpd -k start }
#Restart
function asrs { httpd -k restart }


# Linux
function lnh { wsl.exe --cd "~" }


# Alias
Set-Alias lnx  wsl.exe
Set-Alias vi nvim
Set-Alias sr surreal.exe # Surreal


