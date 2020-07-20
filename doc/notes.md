# Monitor-Printer

[ReadMe](../README.md) > [Notes](notes.md)

______________
## Notes 
02/07/2020

### PROOF OF CONCEPT (POC)

I've written the following Powershell script in 5 minutes.

The __printmanagment__  module has cmd-lets that returns all required informations.

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
________________________
### FIRST RELEASE

I've spent about 2.5 hours for turning these few lines of code into something more robust, reusable and more importantly configurable in the future.

I've added logging functionality, decoupled part of external functionalities into libraries (in a lib folder) and finally listed a set of useful tests (still in progress) for code coverage and continuous integration (CI).

I've re-organised the documentation and readme (another 30 minutes). 

____________________________________

## Notes 
20/07/2020

### SECOND RELEASE

I've spent about 1.5 hours for adding the [improvements](improvements.md) on long printing jobs and another 15 minutes re-organise and update the documentation.
