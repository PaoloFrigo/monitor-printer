#Paolo Frigo, https://www.scriptinglibrary.com

function Append-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LogFile,

        [Parameter(Mandatory = $true)]
        [string]$Message

    )

    begin {
        if ((Test-Path -Path $LogFile) -ne $true){
            #Throw "This log file doesn't exists!"
            # Instead of throwing an error it's simply possible to create the file.
            Write-Warning "$LogFile is missing"
            $CurrentPath = Get-Location
            foreach ($dir in $Logfile.Split("\")){
                if ($dir -match ".log"){
                    set-content -path "$dir" -value ""
                    break
                }
                else {
                    New-Item -ItemType Directory $dir
                    set-location $dir
                }
            }
            Write-Output "Log fodler and file created: $Logfile"
            Set-Location $CurrentPath
        }

    }

    process {
        $time = get-date -format "dd/MM/yyyy hh:mm:ss"
        Add-Content -Path $LogFile -Value "$time - $message"
    }

    end {
    }
}
