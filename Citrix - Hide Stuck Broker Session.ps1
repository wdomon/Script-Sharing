#Hides a Citrix Session to allow a user to log in when a session is stuck

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

Add-PSSnapin Citrix*

$controller = "controller1"

$username = Read-Host "Please enter the username of the stuck Citrix session"

try {
    $session = Get-BrokerSession -AdminAddress $controller -MaxRecordCount 1000 | Where-Object {$_.username -like "*$username*"}
} catch {
    $_.Exception.Message
    LogWrite $_.Exception.Message
}

if ($($session.count) -lt "1") {
    Write-Host -BackgroundColor red -ForegroundColor white "No sessions found containing that username"
} else {
    $confirm = Read-Host "This will hide the $($session.count) session(s) for $username. Are you sure you want to do this? [Y/N]"
    if ($confirm.ToLower() -eq "y") {
        $session | Set-BrokerSession -Hidden $true
    } else {
        Read-Host "Exiting script per input. Press [Enter] to exit..."
        exit
    }
}
