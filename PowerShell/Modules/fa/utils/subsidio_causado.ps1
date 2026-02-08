function sbc{
  param(
    [double]$ImporteGravado = 315.05,
    [double]$Dias = 1,
    [bool]$SEC = $false #SEC = Subsidio al Empleo Causado
  )

  # Leer el archivo de Subsidio Causado
  $SEMensual = 536.21
  $MesPromedio = 30.399990
  $DiasPromPagados = 1.013333 * $Dias
  $Subsidio = 0

  if($SEC -eq $false){
    $Result = ($SEMensual/$MesPromedio) * $DiasPromPagados
    $Subsidio = [math]::Round($Result,2)
    Write-Host "Subsidio: $($Subsidio)"
  }
  else {
    $Subsidio = 0
  }


  # Leer el archivo que corresponda a la tabla de ISR seleccionada
  $LimInferior = 3537.16
  $Tasa = 0.1088
  $Cuota = 207.75

  $Lim = $ImporteGravado-$LimInferior
  $ISR = (($Lim * $Tasa) + $Cuota) - $Subsidio
  Write-Host  "ISR: $($ISR)"
}
