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

LogWrite "** STARTING Uninstall Windows 10 Bloatware Script **"

$bloatware = @(
    "*3DBuilder*"
    "*Bing*"
    "*CandyCrush*"
    "*DellInc.DellDigitalDelivery*"
    "*Dropbox*"
    "*Facebook*"
    "*feedbackhub*"
    "*freshpaint*"
    "*gethelp*"
    "*getstarted*"
    "*king.com*"
    "*Linkedin*"
    "*maps*"
    "*Microsoft.Messaging*"
    "*Microsoft.MsixPackagingTool*"
    "*Microsoft.OneConnect*"
    "*Microsoft.People*"
    "*Microsoft.RemoteDesktop*"
    "*Microsoft.YourPhone*"
    "*Microsoft3DViewer*"
    "*MixedReality*"
    "*Netflix*"
    "*Office*"
    "*print3D*"
    "*Sketchable*"
    "*Skype*"
    "*Solitaire*"
    "*soundrecorder*"
    "*Spotify*"
    "*Twitter*"
    "*wallet*"
    "*windowsalarms*"
    "*windowscommunicationsapps*"
    "*Windowsphone*"
    "*xbox*"
    "*xboxapp*"
    "*xboxgameoverlay*"
    "*yourphone*"
    "*Zune*"    
)

foreach ($bloat in $bloatware) {
    if (($app = Get-AppxPackage -AllUsers $bloat) -and ($app.Name -notlike "*XboxGameCallableUI*")) {
        LogWrite "$($app.Name) app found. Uninstalling..."
        try {
            Write-Progress -CurrentOperation "$($app.Name) app found. Uninstalling..." -Activity "Uninstalling"
            $app | Remove-AppxPackage -allusers -EA Stop
        } catch {
                LogWrite "Uninstall of $($app.Name) failed. Error is:"
                LogWrite $_.Exception.Message
        }                
    }
    if ($provapp = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like $bloat}) {
        LogWrite "$($provapp.DisplayName) provisioned app found. Uninstalling..."
        try {
            Write-Progress -CurrentOperation "$($provapp.DisplayName) provisioned app found. Uninstalling..." -Activity "Uninstalling"
            $provapp | Remove-AppxProvisionedPackage -Online -EA Stop
        } catch {
                LogWrite "Uninstall of $($provapp.DisplayName) failed. Error is:"
                LogWrite $_.Exception.Message
        }
    }
}

LogWrite "** ENDING Uninstall Windows 10 Bloatware Script **"