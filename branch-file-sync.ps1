<#
.SYNOPSIS
  This script will sync the Install$ and Package$ shares on the brach servers. It will
  not consume more than %50 of the available bandwidth when ran.
    
.INPUTS
  G:\Scripts\ps\FileShareSync\Branches.csv
  G:\Scripts\ps\FileShareSync\Locations.csv
 
.OUTPUTS
  Log file stored in G:\Scripts\ps\FileShareSync\Logs\Branch_Sync_(Date).log>
 
.NOTES
  Version:        1.0
  Author:         Kevin Larson
  Creation Date:  07-25-2014
  Purpose/Change: Initial script development
  
.EXAMPLE
  G:\Scripts\ps\FileShareSync\Branch_File_Sync.ps1
#>
 
# Import branch server list
$servers = import-csv G:\Scripts\ps\FileShareSync\branches.csv

# For loop
foreach ($server in $servers) {
	$branch = $server.Name
	# Calculate the speed for the transfer
	if (((get-date).hour -gt 19) -or ((get-date).hour -le 06)) { # If between 1900 and 0600 the use 50% of actual bandwidth
		[int]$calc1 = $server.Speed 
		[int]$calc2 = $server.Speed / 2
		[int]$ipg = (($calc1 - $calc2) / ($calc1 * $calc2)) * 512 * 1000
	}
	else { # If between 0601 and 1859 the use 750Kbps
		[int]$calc1 = 1500 
		[int]$calc2 = $calc1 / 4
		[int]$ipg = (($calc1 - $calc2) / ($calc1 * $calc2)) * 512 * 1000
	}
	start-process powershell "-file G:\Scripts\ps\FileShareSync\share.ps1 $branch $ipg"
	
} #end foreach loop            



