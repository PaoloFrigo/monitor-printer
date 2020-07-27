#Paolo Frigo, https://www.scriptinglibrary.com


function Teams-Notification {
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
        "@type": "MessageCard",
        "@context": "https://schema.org/extensions",
        "summary": "Monitor-Printer Bot",
        "themeColor": "D778D7",
        "title": "Monitor-Printer Bot",
         "sections": [
            {
                "text": "MESSAGE"
            }
        ]
    }
"@

    Invoke-RestMethod -uri $ChannelUri -Method Post -body $BodyTemplate.replace("MESSAGE", $Message) -ContentType 'application/json'
}
