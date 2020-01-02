#This script will enable Remote Desktop and activate the RDP Windows Firewall rule, then restart the Remote Desktop Services service.

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

LogWrite "** STARTING Enable RDP Script **"

$fdeny = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'

if (($fdeny).fDenyTSConnections -ne '0') {
  Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
  Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
  Stop-Service -Name "UmRdpService" -Force
  Restart-Service -Name "TermService" -Force
  Start-Service -Name "UmRdpService"
  Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
  LogWrite "RDP Enabled and service restarted"
} else {
    LogWrite "RDP is already enabled on this device"
}

LogWrite "** ENDING Enable RDP Script **"