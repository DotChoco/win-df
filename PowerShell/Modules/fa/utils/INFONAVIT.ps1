# Percent
function infp{
  param([object[]]$Data)
  $BD = [decimal]$Data[0] #Base Day's
  $INC = [decimal]$Data[1] #Incidents
  $INS = [decimal]$Data[2] #Insurance
  $PT = [decimal]$Data[3] #Payroll Times
  $BS = [decimal]$Data[4] #Base Salary
  $PERC = [decimal]$Data[4] #OFF Percent

  $DFF = $BS * $PERC #Dayly OFF
  $SUBTOTAL = $DFF * ($BD - $INC)
  $OFF = $SUBTOTAL + $INS

  return (scale ($OFF/$PT),6)
}


# TMS(Times Minimum Salary)
function inft{
  param([object[]]$Data)
  $BD = [decimal]$Data[0] #Base Day's
  $INC = [decimal]$Data[1] #Incidents
  $INS = [decimal]$Data[2] #Insurance
  $PT = [decimal]$Data[3] #Payroll Times
  $BA = [decimal]$Data[5] #Bimonthly Amortization

  $DFF = $BA / $BD #Dayly OFF
  $SUBTOTAL = $DFF * ($BD - $INC)
  $OFF = $SUBTOTAL + $INS

  return (scale ($OFF/$PT),6)
}


# Fixed Fee
function inff{
  param([object[]]$Data)
  $BD = [decimal]$Data[0] #Base Day's
  $INC = [decimal]$Data[1] #Incidents
  $INS = [decimal]$Data[2] #Insurance
  $PT = [decimal]$Data[3] #Payroll Times
  $BFF = [decimal]$Data[4] #Bimonthly Fixed Fee

  $DFF = $BFF / $BD #Dayly Fixed Fee
  $SUBTOTAL = $DFF * ($BD - $INC)
  $OFF = $SUBTOTAL + $INS

  return (scale ($OFF/$PT),6)
}

