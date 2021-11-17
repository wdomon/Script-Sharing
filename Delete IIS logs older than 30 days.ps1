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

    $iis_servers = @(
        "server1"
        "server2"
        "server3"
    )
    
    foreach ($iis_server in $iis_servers) {
try {
    $local30 = Invoke-Command -ComputerName $iis_server -ErrorAction Stop -ScriptBlock {
        $iislocalpath = "C:\inetpub\logs\LogFiles"
        if (Test-Path -Path "$iislocalpath") {
        $over30 = Get-ChildItem -Path "$iislocalpath" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))}
        $over30.count
        }
    }
} catch {
    $ErrorMessage = $_.Exception.Message
    LogWrite "IIS Log cleanup failed on $iis_server with error:"
    LogWrite $ErrorMessage
}

    if ($local30) -gt 0) {
        try {
            LogWrite "Deleting $local30 files older than 30 days on $iis_server."
            Invoke-Command -ComputerName $iis_server -Credential $srv_cred -ErrorAction Stop -ScriptBlock {
                $iislocalpath = "C:\inetpub\logs\LogFiles"
                Get-ChildItem -Path "$iislocalpath" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item -Force -Recurse -Confirm:$false
            }
        } catch {
            $ErrorMessage = $_.Exception.Message
            LogWrite "IIS Log cleanup failed on $iis_server with error:"
            LogWrite $ErrorMessage
        }

    }
}

} catch {
    $ErrorMessage = $_.Exception.Message
    LogWrite "IIS Log cleanup failed with error:"
    LogWrite $ErrorMessage
}

LogWrite "** ENDING Clear IIS Logs Script **"
