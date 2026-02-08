## Calculate the Aguinaldo
function Aguinaldo{
  param([object[]]$Data)
  $SBD = [double]$Data[0]
  $DA = if($DA -lt 1){ 15 } else{ [double]$Data[1] }
  $DL = [double]$Data[2]

  if($DL -lt 365) { return scale ($SBD * $DA * ($DL/365)),2 }
  else { return scale ($SBD * $DA),2 }
}



## Calculate the ISR from(FA Nomina)
function ISR{
  param([object[]]$Data)
  [decimal]$SueldoDiario= $Data[0]
  [int]$Periodicidad=if([int]$Data[1] -lt 1){ 0 } else{ [int]$Data[1] }
  [int]$Decimals=if([int]$Data[2] -gt 6 ){ 2 } else{ [int]$Data[2] }

 $mapa = @{
    1 = "bim.csv"
    2 = "cato.csv"
    3 = "dece.csv"
    4 = "men.csv"
    5 = "quin.csv"
    6 = "sem.csv"
  }

  # Set the value from the map if exists, else set the default value "dia.csv"
  $file = if ($mapa.ContainsKey($Periodicidad)) { "isr_" + $mapa[$Periodicidad] } else { "isr_dia.csv" }
  $data = Import-Csv -Path "$CONTADIR/docs/$file" -Delimiter ','

  foreach ($row in $data) {
    # Convert the fields to decimal values
    [decimal]$limInf = $row.'Límite Inferior'
    [decimal]$limSup = $row.'Límite Superior'
    [decimal]$cuota  = $row.'Cuota Fija'
    [decimal]$tasa   = [decimal]$row.'% Excedente' / 100

    if ($SueldoDiario -ge $limInf -and $SueldoDiario -le $limSup) {
      $impuesto = (($SueldoDiario - $limInf) * $tasa) + $cuota
      return (scale $impuesto,$Decimals)
    }
  }
}

## Calculate the Subsidio Causado
function ssb{
  param([object[]]$Data)

  [int]$DPG=if([int]$Data[0] -lt 1){ 1 } else{ [int]$Data[0] } #Dias pagados
  [int]$Decimals=if([int]$Data[1] -gt 6 ){ 3 } else{ [int]$Data[1] }

  $DP=30.4
  $UMA=3439.46
  $SMP=10171
  $PERC=0.1380

  $RES = ($UMA * $PERC/ $DP) * $DPG

  return (scale $RES,$Decimals)
}





