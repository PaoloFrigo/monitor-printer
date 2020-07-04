# Monitor-Printer

[ReadMe](README.md)

## DESCRIPTION

This Powershell script it is designed to be scheduled and for monitoring status and number of jobs in the queue of any installed printer on a Windows Workstation or Server.

If the number of jobs exceeds the specific threshold set by the user a notification is sent with the critical state to the user via a chat message via a Teams/Slack channel.

## REQUIREMENTS

All the [requirements](doc/requirements.md) for this solution were provided by Kay Van Aarssen [(ICTWebSolutions)](www.ictwebsolution.nl).

## AUTHOR
Paolo Frigo [(www.scriptinglibrary.com)](https://www.scriptinglibrary.com)

## NOTES

[Author notes and informations](doc/notes.md)

## CONFIGURATION / SETTINGS

User settings are included in this region, placed in the top of the __monitor-printer.ps1__ script.

```powershell
#region USER SETTINGS
$PrinterName                = "AutoDoc HSE"
$CriticalThreshold          = 8 
$NotificationChannelTokens  = ("", "")# expects multiple values, comma separated like https://hooks.slack.com/... or https://outlook.office.com/webhook/...
$LogFile                    = "monitor-printer.log"
#endregion
```

This a summary of the settings with type and description.

|Key|Type|Description|
|---|---|---|
|PrinterName| String | Name of the printer to monitor (e.g. "AutoDoc HSE") |
|CriticalThreshold|Int| Number of pring jobs in the queue which if breached will trigger a notification|
|NotificationChannelTokes|String[]|List of webhook url (uri+token) addresses for sending inbound messages to MS Teams or Slack channels|
|LogFile|String|Name of the logfile with extension (e.g. monitor-printer.log)|

## RUNNING THIS SCRIPT AS A SCHEDULED TASK/JOB

This script can run on demand or can be scheduled to run periodically.

Regarding scheduling this script the choice between using [Task Scheduler or Powershell Scheduled Jobs](https://devblogs.microsoft.com/scripting/using-scheduled-tasks-and-scheduled-jobs-in-powershell/) is left to the administrator.
