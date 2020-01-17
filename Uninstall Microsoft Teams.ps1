  #Function to generate a timestamp that is added to the log file
function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)   
    }
    
    #Function to generate a log file
    if ((Test-Path -Path "$ENV:SystemDrive\Scripts" -PathType Container) -ne $true ) {mkdir "$ENV:SystemDrive\Scripts" | Out-Null}
    $LogFile = "$ENV:SystemDrive\Scripts\Logs.log"
    Function LogWrite
    {
      Param ([string]$logstring)
      Add-content $Logfile -value "$(Get-Timestamp) $logstring"
    }

LogWrite "** STARTING Uninstall MS Teams Script **"

    # Removal Machine-Wide Installer - This needs to be done before removing the EXE!
    Try {
        Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "Teams Machine-wide Installer"} | Remove-WmiObject
    } Catch {
        LogWrite "Teams Machine-Wide Installer not found."
        LogWrite "** ENDING Uninstall MS Teams Script **"
        exit
    }

    #Variables
    $TeamsUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"

     $TeamsUsers | ForEach-Object {
        Try { 
            if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams") {
                LogWrite "Teams found for user $($_.Name), uninstalling..."
                Start-Process -FilePath "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList "-uninstall -s" -EA Stop
            }
        } Catch { 
            LogWrite "Teams app Uninstall for user $($_.Name) Failed! Error Message:"
            LogWrite $_.Exception.Message
            Out-Null
        }
    }

    LogWrite "** ENDING Uninstall MS Teams Script **"