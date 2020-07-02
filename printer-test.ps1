#requires -module printmanagement

#USER SETTINGS
$PrinterName        = "AutoDoc HSE"
$CriticalThreshold  = 8

#REQUIREMENTS
$PrinterStatus = (Get-Printer -Name $PrinterName).printerstatus     #STRING
$NumberOfPrintJobs = (Get-PrintJob -PrinterName $PrinterName).Count #INT 
$Critical = $CriticalThreshold -ge $NumberOfPrintJobs               #BOOLEAN

#Printout 
Write-Output $PrinterName, $PrinterStatus, $NumberOfPrintJobs, $Critical 