#requires -module printmanagement

#Paolo Frigo, https://www.scriptinglibrary.com

#USER SETTINGS
$PrinterName        = "AutoDoc HSE"
$CriticalThreshold  = 8

#REQUIREMENTS
$PrinterStatus = (Get-Printer -Name $PrinterName).printerstatus         #STRING
$NumberOfPrintJobs = 9 #(Get-PrintJob -PrinterName $PrinterName).Count  #INT 
$Critical = $NumberOfPrintJobs -ge $CriticalThreshold                   #BOOLEAN

#Printout 
Write-Output $PrinterName, $PrinterStatus, $NumberOfPrintJobs, $Critical 