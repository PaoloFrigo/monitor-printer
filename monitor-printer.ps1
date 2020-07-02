#requires -module printmanagement

#Paolo Frigo, https://www.scriptinglibrary.com

#region SET THE WORKING DIRECTORY
Set-Location -path $PSScriptRoot
#endregion 

#region USER SETTINGS
$PrinterName                = "AutoDoc HSE"
$CriticalThreshold          = 8 
$NotificationChannelTokens  = ("", "")# expects multiple values, comma separated like https://hooks.slack.com/... or https://outlook.office.com/webhook/...
$LogFile                    = "monitor-printer.log"
#endregion


#region CHECK DEPENDENCIES AND IMPORT THEM WITH DOT SOURCING
$Dependencies = "\lib\append-log.ps1", "\lib\slack-notification.ps1", "\lib\teams-notification.ps1"

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
$Critical = $NumberOfPrintJobs -ge $CriticalThreshold               #BOOLEAN
#endregion 

#region NOTIFICATION
if ($Critical) {
    $Message = "CRITICAL: $PrinterName (state: $PrinterStatus). Jobs currently in queue: $NumberOfPrintJobs at $(Get-Date)"

    Write-Warning $Message
    Append-Log -LogFile $LogFile -Message $Message
    
    foreach ($ChannelURI in $NotificationChannelTokens){
        if ($ChannelURI -like ""){
            break 
        }       
        elseif ($ChannelURI -match "hooks.slack.com"){            
            Slack-Notification -ChannelUri $ChannelURI -Message $Message
            Append-Log -LogFile $LogFile -Message "Slack notification sent"
        }
        elseif ($ChannelURI -match "outlook.office.com"){
            Teams-Notification -ChannelUri $ChannelURI -Message $Message
            Append-Log -LogFile $LogFile -Message "Teams notification sent"
        }           
        else{
            Append-Log -LogFile $LogFile -Message "unrecognized notification uri, please check your user settings"
            Throw "UNRECOGNIZED NOTIFICATION URI, PLEASE CHECK YOUR USER SETTINGS"
        }
    } 
}
#endregion
exit 0