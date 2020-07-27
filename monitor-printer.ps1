#requires -module printmanagement

# Monitor-Printer V.1.1
#Paolo Frigo, https://www.scriptinglibrary.com

#region SET THE WORKING DIRECTORY
Set-Location -path $PSScriptRoot
#endregion

#region CHECK DEPENDENCIES AND IMPORT THEM WITH DOT SOURCING
$Dependencies = "\config-setting.ps1", "\lib\append-log.ps1", "\lib\slack-notification.ps1", "\lib\teams-notification.ps1"

foreach ($Dependency in $Dependencies){
    if ((Test-Path "$($PSScriptRoot)$Dependency") -eq $False){
        throw "MISSING DEPENDENCY: File not found `"$($PSScriptRoot)$Dependency`""
    }
    else {
        . $PSScriptRoot$Dependency
    }
}
#endregion

# CREATE A LOG FILE IF IS NOT EXISTS
if ((Test-Path -Path $LogFile) -eq $false){
    New-Item "$LogFile"
}
#endregion

# CREATE A PrintingJobXMLFile FILE IF IS NOT EXISTS
if ((Test-Path -Path $PrintingJobXMLFile) -eq $false){
    "" | Select-Object computername, printername, jobstatus, id, documentname, pagesprinted, totalpages, size, username, submittedtime,NotePropertyValue |  Export-Clixml "$PrintingJobXMLFile"
}
#endregion

# FAIL FAST THE PRINTER NAME IS NOT PRESENT
try{
    if ($printername -notin $(get-printer|Select-Object -exp Name)){
        Append-Log -LogFile $LogFile -Message "$PrinterName not found. please check your user settings"
        Throw "$PrinterName NOT FOUND. PLEASE CHECK YOUR USER SETTINGS"
    }
}
catch {
    Throw "$PrinterName NOT FOUND. PLEASE CHECK YOUR USER SETTINGS"
}
#region REQUIREMENTS
$PrinterStatus = (Get-Printer -Name $PrinterName).printerstatus     #STRING
$NumberOfPrintJobs = (Get-PrintJob -PrinterName $PrinterName).Count #INT
$LastPrintingJob =  Import-Clixml $PrintingJobXMLFile               #HASHTABLE
#endregion

#region Jobs in Printing state
$PrintingJob = get-printjob -PrinterName $PrinterName |
    Where-Object {$_.jobstatus -match "Printing"} |
        Select-Object computername, printername, jobstatus, id, documentname, pagesprinted, totalpages, size, username, submittedtime |
            Add-Member -NotePropertyName "printingat" -NotePropertyValue "$(get-date)"

if ($PrintingJob){
    $LongRunningPrintingJob = ($PrintingJob.id -eq $LastPrintingJob.id) -and ([datetime]$PrintingJob.StillPrintingAt) -lt $(get-date).AddMinutes($TimeThresholdPrintingJob)
    if ($LongRunningPrintingJob -eq $False){
        $PrintingJob | Export-Clixml $PrintingJobXMLFile #update the XML File
    }
}
else {
    #There are no long running printing jobs
    "" | Select-Object computername, printername, jobstatus, id, documentname, pagesprinted, totalpages, size, username, submittedtime,NotePropertyValue |  Export-Clixml "$PrintingJobXMLFile"
    $LongRunningPrintingJob = $false
}
#endregion

$Critical = ($NumberOfPrintJobs -ge $CriticalThreshold) -or $LongRunningPrintingJob    #BOOLEAN

#region NOTIFICATION
if ($Critical) {
    $Message = "CRITICAL: $PrinterName (state: $PrinterStatus). Jobs currently in queue: $NumberOfPrintJobs at $(Get-Date)."

    if ($LongRunningPrintingJob){
        $Message += " Job ID $($LastPrintingJob.id) still in PRINTING state since $($LastPrintingJob.StillPrintingAt) by User $($LastPrintingJob.username) on $($LastPrintingJob.computername), document name: $($LastPrintingJob.documentname) - printed pages: $($LastPrintingJob.pagesprinted)/$($LastPrintingJob.totalpages) - size $($LastPrintingJob.size)"
    }

    Write-Warning $Message
    Append-Log -LogFile $LogFile -Message $Message

    foreach ($ChannelURI in $NotificationChannelTokens){
        if ($ChannelURI -like ""){
            break
        }
        elseif ($ChannelURI -match "hooks.slack.com"){
            Slack-Notification -ChannelUri $ChannelURI -Message $Message
            Append-Log -LogFile $LogFile -Message "NOTIFICATION: Slack notification sent"
        }
        elseif ($ChannelURI -match "outlook.office.com"){
            Teams-Notification -ChannelUri $ChannelURI -Message $Message
            Append-Log -LogFile $LogFile -Message "NOTIFICATION: Teams notification sent"
        }
        else{
            Append-Log -LogFile $LogFile -Message "unrecognized notification uri, please check your user settings"
            Throw "UNRECOGNIZED NOTIFICATION URI, PLEASE CHECK YOUR USER SETTINGS"
        }
    }
}
#endregion
exit 0