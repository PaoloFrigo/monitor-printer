# Monitor-Printer

[ReadMe](README.md)

## DESCRIPTION

This Powershell script it is designed for monitoring status and number of jobs in the queue of any installed printer on a Windows Workstation or Server.

If the number of jobs exceeds the specific threshold set by the user a notification is sent with the critical state to the user via a chat message via a Teams/Slack channel.

The execution can be scheduled or run on demand.

## REQUIREMENTS

All the [requirements](doc/requirements.md) for this solution were provided by Kay Van Aarssen [(ICTWebSolutions)](www.ictwebsolution.nl). Please see the note section for updates.

## AUTHOR
Paolo Frigo [(www.scriptinglibrary.com)](https://www.scriptinglibrary.com)

## NOTES

* [Author notes and informations](doc/notes.md)
* [Improvements after the first release](doc/improvements.md)

## CONFIGURATION / SETTINGS

User settings are included in this region, placed in the top of the __monitor-printer.ps1__ script.

```powershell
$PrinterName                = "AutoDoc HSE"
$CriticalThreshold          = 8 
$NotificationChannelTokens  = ("", "")# expects multiple values, comma separated like https://hooks.slack.com/... or https://outlook.office.com/webhook/...
$LogFile                    = "monitor-printer.log"
$PrintingJobXMLFile         = "last-printing-job.xml"
$TimeThresholdPrintingJob   = 5 # minutes
```

This a summary of the settings with type and description.

|Key|Type|Description|
|---|---|---|
|PrinterName| String | Name of the printer to monitor (e.g. "AutoDoc HSE") |
|CriticalThreshold|Int| Number of pring jobs in the queue which if breached will trigger a notification|
|NotificationChannelTokes|String[]|List of webhook url (uri+token) addresses for sending inbound messages to MS Teams or Slack channels|
|LogFile|String|Name of the log file including the extension (e.g. monitor-printer.log)|
|PrintingJobXMLFile|String|Name of the xml file including the extension (e.g. last-printing-job.xml)|
|TimeThresholdPrintingJob|Int|Max number of minutes for a job in PRINTING state (e.g. 5)|

## RUNNING THIS SCRIPT AS A SCHEDULED TASK/JOB

This script can run on demand or can be scheduled to run periodically.

Regarding scheduling this script the choice between using [Task Scheduler or Powershell Scheduled Jobs](https://devblogs.microsoft.com/scripting/using-scheduled-tasks-and-scheduled-jobs-in-powershell/) is left to the administrator.


## CUSTOMIZING NOTIFICATIONS
MS Teams Slack Notifications can be tweaked by changing the template in the __slack-notification.ps1__ or __teams-notification.ps1__ script included the lib folder.

These settings have been left __'hard-coded'__ to avoid validating or managing malformed request and errors with the respective services. 

All information to edit these templetes will be available on the official website of the service provider.

## LOGGING

If you need to change your logging settings or format you can edit your __append-log.ps1__ script.

This shows the simple log functionality. 

```
02/07/2020 11:28:06 - CRITICAL: AutoDoc HSE (state: Paused). Jobs currently in queue: 9 at 07/02/2020 20:28:06
02/07/2020 11:28:07 - NOTIFICATION: Slack message sent
02/07/2020 11:31:08 - CRITICAL: AutoDoc HSE (state: Paused). Jobs currently in queue: 9 at 07/02/2020 20:31:08
02/07/2020 11:31:09 - NOTIFICATION: Slack message sent
02/07/2020 11:31:11 - NOTIFICATION: Teams message sent
20/07/2020 10:17:36 - CRITICAL: AutoDoc HSE (state: Normal). Jobs currently in queue: 6 at 07/20/2020 22:17:36. Job ID 9 still in PRINTING state since 07/20/2020 21:10:02 by User Administrator on MyServer, document name: Test Page - printed pages: 1/1 - size 4584819
20/07/2020 10:17:37 - NOTIFICATION: Slack notification sent
20/07/2020 10:17:39 - NOTIFICATION: Teams message sent

```

To display just the CRITICAL status you can use this one-liner

```powershell
Get-Content .\monitor-printer.log | Select-String -AllMatches "CRITICAL"

02/07/2020 11:28:06 - CRITICAL: AutoDoc HSE (state: Paused). Jobs currently in queue: 9 at 07/02/2020 23:28:06
02/07/2020 11:31:08 - CRITICAL: AutoDoc HSE (state: Paused). Jobs currently in queue: 9 at 07/02/2020 23:31:08
20/07/2020 10:17:36 - CRITICAL: AutoDoc HSE (state: Normal). Jobs currently in queue: 6 at 07/20/2020 22:17:36. Job ID 9 still in PRINTING state since 07/20/2020 21:10:02 by User Administrator on MyServer, document name: Test Page - printed pages: 1/1 - size 4584819
```