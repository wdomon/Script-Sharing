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

LogWrite "** STARTING Remove TeamViewer Icon Script **"

#Variables
$pub = Test-Path -Path "$ENV:PUBLIC\Desktop\TeamViewer*Host.lnk"
$userdirs = Get-ChildItem -Path "$ENV:SystemDrive\Users"

Try {
    if ($pub) {
        LogWrite "TV icon found on Public Desktop. Removing..."
        Remove-Item -Path "$ENV:PUBLIC\Desktop\TeamViewer*Host.lnk"
    }
} Catch {
    LogWrite "TV icon on Public Desktop failed to remove. Error Message:"
    LogWrite $_.Exception.Message
}

$userdirs | ForEach-Object {
    Try {
        if (Test-Path "$ENV:SystemDrive\Users\$($_.Name)\Desktop\TeamViewer*Host.lnk") {
            LogWrite "TV icon found on $($_.Name) desktop. Removing..."
            Remove-Item -Path "$ENV:SystemDrive\Users\$($_.Name)\Desktop\TeamViewer*Host.lnk"
        }
    } Catch {
        LogWrite "TV icon on $($_.Name) desktop failed to remove. Error Message:"
        LogWrite $_.Exception.Message
        Out-Null
    }
}

LogWrite "** ENDING Remove TeamViewer Icon Script **"
