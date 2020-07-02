# Monitor-Printer

## Printer Monitoring and Alerting Solution
Notes from skype chat 22/06/2020

## SCENARIO

An Autodoc HSE Printer (by streamlinesoftware.net) is installed on a window server and the number of printing jobs in the queue can grow during the day to few thousands.

Frequently the printer is rebooted to get it to function properly and users will submit the print jobs again.

## SOLUTION DESCRIPTION

Writing a script capable of monitoring the printer status and queue size and trigger Teams/Slack notification message if the number of jobs is bigger than a threshold value or if the printer is not in the desired state (e.g. ready/online).

## REQUIREMENTS

1. Reading the number of Jobs in the print queue for a specific printer.
2. Reading the status of a specific printer.
3. Setting up a threshold and desidered state to trigger notifications.
4. Trigger webhook notifications to slack/teams.
5. Notification message should include the __printer state__ and __size of the queue__.
6. Configurable printer name (or list of printer names).
7. Configurable thresholds value for the notification (queue size/state).
8. Configurable webhook url for Slack and Teams.
9. Exit values required for TaskSchelduler.

## Nice to haves (If not to much work)

- If a printer is in an error state for (lets say) 2 day's send notification that Printer X is in error for X days
- How to know if the printer is in error state. Write a log somewhere so that keeps track of the printer sate or something. Think you have a better view at what we can use fo this.


## Notes 02/07/2020

I've wrote this in 5 minutes.
```
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
I've spent about 2.5 hours to make it more reusable and configurable in the future and adding loggin and libraries.

