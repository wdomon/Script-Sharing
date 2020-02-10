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

LogWrite "** STARTING Clear IIS Logs Script **"

$w3svc = Get-ChildItem -Path "C:\inetpub\logs\LogFiles"

foreach ($w3 in $w3svc) {
    LogWrite "Deleting files older than 30 days in $w3"
    Forfiles.exe -p "C:\inetpub\logs\LogFiles\$w3" -m *.log -d -30 -c "Cmd.exe /C del @path"
}

LogWrite "** ENDING Clear IIS Logs Script **"