$AccountLockOutEvent = Get-EventLog -LogName "Security" -InstanceID 4740 -Newest 1
$LockedAccount = $($AccountLockOutEvent.ReplacementStrings[0])
$AccountLockOutEventTime = $AccountLockOutEvent.TimeGenerated
$AccountLockOutEventMessage = $AccountLockOutEvent.Message
$ServerName = $env:ComputerName
$ToField = "email@youremail.com"
$messageParameters = @{ 
Subject = "User Account Locked Out: $LockedAccount" 
Body = "User account $LockedAccount was locked out on $AccountLockOutEventTime.`n`nEvent Details:`n`n$AccountLockOutEventMessage"
From = "alert@youremail.com" 
To = $ToField
SmtpServer = "mail.server.com" 
} 
