#requires -module  @{ ModuleName="Pester"; ModuleVersion="5.0.0" }
#Paolo Frigo, https://www.scriptinglibrary.com

. $PSScriptRoot\config-setting.ps1


describe "DEPENDENCY CHECKS" {

    it "fails if one libary is missing"{
        Mock Get-Printer {
            $MyPrinter = "" | Select-object "Name","ComputerName","Type","DriverName","PortName","Shared","Published","DeviceType"
            $MyPrinter.Name = $printername
            return $myprinter
        }
        Mock Get-PrintJob {
            return
        }
        Mock New-Item {}
        mock "Test-Path"{ $False }
        {. $PSScriptRoot\monitor-printer.ps1  } | Should -Throw
    }
}

describe "FUNCTIONAL CHECKS" {
    it "creates a log file if does not exists"{
        Mock Get-Printer {
            $MyPrinter = "" | Select-object "Name","ComputerName","Type","DriverName","PortName","Shared","Published","DeviceType"
            $MyPrinter.Name = $printername
            return $myprinter
        }
        Mock Get-PrintJob {
            return
        }
        Mock Test-Path -ParameterFilter {$Path -like $LogFile} {Return $False}
        Mock New-Item { $False}
        Mock Add-Content {$True}
        . $PSScriptRoot\monitor-printer.ps1
        Assert-MockCalled New-Item
    }


    it "fails if printername `"$($PrinterName)`" is not found"{
        Mock Write-Warning {}
        Mock Add-Content {$True}
        Mock Set-Content {$True}
        Mock Get-Printer {
            $MyPrinter = "" | Select-object "Name","ComputerName","Type","DriverName","PortName","Shared","Published","DeviceType"
            $MyPrinter.Name = ""
            return $myprinter
        }
        Mock Get-PrintJob {
            return
        }
        Mock New-Item {}
        { . $PSScriptRoot\monitor-printer.ps1 } | Should -throw "* NOT FOUND. PLEASE CHECK YOUR USER SETTINGS"

    }

    it "if number of jobs in the queue > the critical threshold `($($CriticalThreshold)`) trigger the notifications"{
        Mock Write-Warning {}
        Mock Add-Content {$True}
        Mock Set-Content {$True}
        Mock Get-Printer {
            $MyPrinter = "" | Select-object "Name","ComputerName","Type","DriverName","PortName","Shared","Published","DeviceType"
            $MyPrinter.Name = $printername
            return $myprinter
        }
        Mock Get-PrintJob {# -ParameterFilter {$printername -like $PrinterName} {
            $FakeJobsList = [int[]]::new( $CriticalThreshold + 1 )
            return $FakeJobsList
        }
        Mock New-Item {}
        . $PSScriptRoot\monitor-printer.ps1
        Assert-MockCalled Write-Warning -ParameterFilter {$Message -like "CRITICAL*"}
    }
}