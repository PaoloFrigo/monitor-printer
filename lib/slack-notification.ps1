#Paolo Frigo, https://www.scriptinglibrary.com
function Slack-Notification {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $ChannelUri,
        [Parameter(Mandatory=$true)]
        [string]
        $Message  
    )

    $BodyTemplate = @"
    {
    "channel": "#general",
    "username": "Monitor-Printer Bot",
    "text": "MESSAGE",
    "icon_emoji":":printer:"
    }
"@
        
    Invoke-RestMethod -uri $ChannelUri -Method Post -body $BodyTemplate.replace("MESSAGE", $Message) -ContentType 'application/json'
}


#Slack-Notification -ChannelUri "***REMOVED***" -Message "This is another test at $(get-date)"