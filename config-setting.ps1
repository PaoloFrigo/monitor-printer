# Monitor-Printer V.1.1
#Paolo Frigo, https://www.scriptinglibrary.com

#region USER SETTINGS
$PrinterName                = "AutoDoc HSE"
$CriticalThreshold          = 8 
$NotificationChannelTokens  = ("", "")# expects multiple values, comma separated like https://hooks.slack.com/... or https://outlook.office.com/webhook/...
$LogFile                    = "monitor-printer.log"
$PrintingJobXMLFile         = "last-printing-job.xml"
$TimeThresholdPrintingJob   = 5 # minutes
#endregion