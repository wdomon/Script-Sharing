#Function to generate a timestamp that is added to the log file
function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)   
    }
    
    #Function to generate a log file
    if ((Test-Path -Path "$ENV:SystemDrive\Scripts" -PathType Container) -ne $true ) {mkdir $ENV:SystemDrive\Scripts | Out-Null}
    $LogFile = "$ENV:SystemDrive\Scripts\Logs.log"
    Function LogWrite
    {
      Param ([string]$logstring)
      Add-content $Logfile -value "$(Get-Timestamp) $logstring"
    }

LogWrite "** STARTING Delete all print queues Script **"

Stop-Service spooler -Force
$files = Get-ChildItem -Path "$env:SystemRoot\System32\spool\PRINTERS" -Force
LogWrite "Removing $($files.Count) printer queue files"
$files | Remove-Item -Force
Start-Service spooler


LogWrite "ENDING Delete all print queues SCRIPT"