# Monitor-Printer

[ReadMe](../README.md) > [Notes](notes.md)

## Notes 
02/07/2020

### PROOF OF CONCEPT (POC)

I've wrote this following Powershell script in 5 minutes.

The __printmanagment__  module have cmdlet that returns all the desired informations needed.

```powershell
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
```

### FIRST RELEASE

I've spent about 2.5 hours for turning these few lines of code into something more reusable and configurable in the future.

I've added logging functionality, decoupled part of external functionalities into libraries (in a lib folder) and finally listed a set of useful tests (still in progress) for code coverage and continuous integration (CI).