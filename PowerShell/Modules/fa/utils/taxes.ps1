#Calculate the Tranfer (Without taxes)
function tts{
  param([object[]]$Data)

  #UNIT PRICE
  $UP = [double]$Data[0]

  $IEPS = [double]$Data[1]
  $TAX = [double]$Data[2]
  $DECIMALS = ([int]$Data[3] -gt 0) ? [int]$Data[3] : 2

  #UNIT PRICE IEPS
  $UPI = $UP * $IEPS

  #UNIT PRICE TAX
  $UPTAX = ($UPI + $UP) * $TAX

  #RESULTS
  [double]$TRANSFERS = $UPI + $UPTAX
  [double]$TOTAL = $UP + $TRANSFERS

  $RESULT = scale $TOTAL,$DECIMALS

  Write-Host("Total: " + $RESULT)
  Write-Host("Traslados: " + $TRANSFERS)
}

#Calculate the Tranfer (NETO)
function ttn{
  param([object[]]$Data)

  #UNIT PRICE
  $UP = [double]$Data[0]

  $IEPS = [double]$Data[1]
  $TAX = [double]$Data[2]
  $DECIMALS = ([int]$Data[3] -gt 0) ? [int]$Data[3] : 2

  $MAX_PORCENT = 1
  $TAX_PORCENT = $TAX + $MAX_PORCENT
  $IEPS_PORCENT = $IEPS + $MAX_PORCENT

  #UNIT PRICE TAX
  [double]$UPTAX = ($TAX * $UP) / $TAX_PORCENT


  #UNIT PRICE IEPS
  [double]$UPIEPS_SUBSTRACT = $UP - $UPTAX
  [double]$UPI = ($IEPS * $UPIEPS_SUBSTRACT) / $IEPS_PORCENT


  #TRANSFERS & SUBTOTALS
  [double]$TRANSFERS = $UPI + $UPTAX
  [double]$SUBTOTAL = $UP - $TRANSFERS

  #RESULTS
  [double]$RES_SUBTOTAL = scale $SUBTOTAL,$DECIMALS
  [double]$RES_TRANSFERS = scale $TRANSFERS,$DECIMALS
  [double]$RES_TOTAL = $RES_TRANSFERS + $RES_SUBTOTAL

  Write-Host("SubTotal: " + $RES_SUBTOTAL)
  Write-Host("Traslados: " + $RES_TRANSFERS)
  Write-Host("Total: " + $RES_TOTAL)
}


