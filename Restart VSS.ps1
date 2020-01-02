#This script will restart all services, and their dependent services, that will allow VSS Writers to recover

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

LogWrite "** STARTING Restart VSS Script **"

#Declare variables for services that need to be restarted
$SENS = Get-Service SENS
$BITS = Get-Service BITS
$ES = Get-Service EventSystem
$swprv = Get-Service swprv
$vss = Get-Service vss
$all_serv = $SENS,$BITS,$ES,$swprv,$vss

#Declare variables for dependant services
$SENS_dep = Get-Service SENS -DependentServices
$BITS_dep = Get-Service BITS -DependentServices
$ES_dep = Get-Service EventSystem -DependentServices
$swprv_dep = Get-Service swprv -DependentServices
$vss_dep = Get-Service vss -DependentServices
$dep = $sens_dep,$BITS_dep,$ES_dep,$swprv_dep,$vss_dep

#Stops all running dependent services
LogWrite "Stopping Dependent Services..."
foreach ($service in $dep) {
if (($service.status -ne "Running") -and ($service.Count -ge 1)) {
LogWrite "$($service.Name) service is not currently running, skipping..."
}
else {
if (($service.status -eq "Running") -and ($service.Count -ge 1)) {
Stop-Service $service -Force
LogWrite "Stopping $($service.Name) service"
}
}
}

#Restarts all services that need to be restarted
LogWrite "Restart Needed Services..."
foreach ($service in $all_serv) {
LogWrite "Restarting $($service.Name) service"
Restart-Service $service -Force
}

#Starts all dependent services again
foreach ($service in $dep) {
if (($service.status -eq "Running") -and ($service.Count -ge 1)) {
LogWrite "$($service.Name) already restarted itself"
}
else {

if ($service.Count -ge 1) {  
Start-Service $service
LogWrite "Starting $($service.Name) service"
}
}
}


LogWrite "** ENDING Restart VSS Script **"