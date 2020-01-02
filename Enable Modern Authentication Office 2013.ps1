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

LogWrite "** STARTING Enable Modern Authentication Office 2013 Script **"

#Function to check for registry key
function Test-RegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

try {

Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
 return $true
 }

catch {

return $false

}

}
#Check for path to Office 2013 in Registry
If (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\"){

    #Test if registry key Named "Version" already exists
    If (Test-RegistryValue -path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Value 'Version'){

      #If true sets to Value of "1"    
      Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Name "Version" -Value "1"
      LogWrite "Version property already exists. Setting value to 1..."
    
    } 

    Else { 
      #If false makes new key of Type "String" Named "Version" and sets to Value of "1"
      New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Name "Version" -Value "1" -PropertyType "String"
      LogWrite "Version property does not exist. Creating it with value of 1..."

    }

    #Test if registry key Named "EnableADAL" already exists
    If (Test-RegistryValue -path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Value 'EnableADAL'){

      #Test if registry key Named "EnableADAL" already exists
      Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Name "EnableADAL" -Value "1"
      LogWrite "EnableADAL property already exists. Setting value to 1..."
    
    }

    Else { 
      #If false makes new key of Type "String" Named "EnableADAL" and sets to Value of "1" 
      New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\15.0\Common\Identity\" -Name "EnableADAL" -Value "1" -PropertyType "String"
      LogWrite "EnableADAL property does not exist. Creating it with value of 1..."

    }
}
#If Office 2013 settings in registry is False It just exits the script
Else {

    exit

}

LogWrite "** STARTING Enable Modern Authentication Office 2013 Script **"