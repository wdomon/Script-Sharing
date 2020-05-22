param (
    [string]$url = '',
    $xmlpath = "$ENV:SystemDrive\Scripts\WLAN-profile.xml"
)

#Downloads XML file containining WLAN profile from URL then runs command to import that WLAN profile

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

LogWrite "**STARTING WLAN Profile SCRIPT**"


$xmlpath = "$ENV:SystemDrive\Scripts\WLAN-profile.xml"


    try {
        Invoke-WebRequest -Uri $url -OutFile $xmlpath
        LogWrite "Successfully downloaded file to $xmlpath!"
    } catch {
        LogWrite "Failed to download file. Exiting script with error:"
        LogWrite $_.Exception.Message
    }

    try {
        netsh wlan add profile filename="$xmlpath"
        LogWrite "Successfully imported WLAN profile! Bob's your uncle!"
    } catch {
        LogWrite "Failed to import WLAN profile. Exiting script with error:"
        LogWrite $_.Exception.Message
    }

LogWrite "**ENDING WLAN Profile SCRIPT**"