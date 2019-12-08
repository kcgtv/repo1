<#
	Created by: 	Kevin Larson
	Create date:	04/14/2014
	Updated:	10/28/2014
	Version:	v1.1
	Events ID's:	124,4107,2153,1135,7024,7031,1127
	
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -version 2.0 -nexit -command ". 'G:\Program Files\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; \\mgmt\share$\events\DAGFailover.ps1;"
	
#>

$Date = Get-Date -format "M/d/yyyy"
$Time = Get-Date -format "h:mm:ss tt"

[string]$DAGName = Get-DatabaseAvailabilityGroup | Select Name
[string]$DAGName = $DAGName.SubString(7)
[string]$DAGName = $DAGName.trimend("}")

[string]$WitnessServer = Get-DatabaseAvailabilityGroup | Select WitnessServer
[string]$WitnessServer = $WitnessServer.SubString(16)
[string]$WitnessServer = $WitnessServer.trimend("}")

[string]$AltWitnessServer = Get-DatabaseAvailabilityGroup | Select AlternateWitnessServer
[string]$AltWitnessServer = $AltWitnessServer.SubString(25)
[string]$AltWitnessServer = $AltWitnessServer.trimend("}")

[string]$WhenChanged = Get-DatabaseAvailabilityGroup | Select WhenChanged
[string]$WhenChanged = $WhenChanged.SubString(14)
[string]$WhenChanged = $WhenChanged.trimend("}")

[string]$PrimaryActiveManager = Get-DatabaseAvailabilityGroup $DAGName -status | Select PrimaryActiveManager
[string]$PrimaryActiveManager = $PrimaryActiveManager.SubString(23)
[string]$PrimaryActiveManager = $PrimaryActiveManager.trimend("}")

$ServerName = $env:ComputerName
$ToField = "email@yourmail.com"

$messageParameters = @{ 
Subject = "$DAGName failover event detected on $Date at $Time" 
Body = "$DAGName failed over at: $WhenChanged`n
	Primary Active Manager: $PrimaryActiveManager
	Witness server: $WitnessServer
	Alternative Witness server: $AltWitnessServer
	Alert source server: $ServerName"
From = "alert@yourmail.com" 
To = $ToField
SmtpServer = "smtp.server" 
} 
if ($DAGName -ne $null){
	Send-MailMessage @messageParameters
	}
