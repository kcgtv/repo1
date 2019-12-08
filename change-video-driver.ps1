<#
  This script installs the "VMware SVGA 3D (Microsoft Corporation - WDDM)" video driver
  on a Microsoft Windows Server 2008 R2 system.
#>
 
# Check to make sure this script only runs on Microsoft Windows Server 2008 R2 system.
$OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem

if ($OperatingSystem -and $OperatingSystem.Name -like "Microsoft Windows Server 2008 R2 *") {
 
  # Get the display device driver.
  $DisplayDriver = Get-WMIObject -Query "Select * from Win32_PnPSignedDriver Where DeviceClass='DISPLAY'"
   
  # Check to see if we have the WDDM display device driver.
  if ($DisplayDriver -and $DisplayDriver.DeviceName -ne "VMware SVGA 3D (Microsoft Corporation - WDDM)") {
   
    # We have the wrong driver. We need to install the correct one.
    # Check if the VMware Tools are installed and the WDDM driver can be found.
    $WddmFile = "c:\program files\common files\vmware\drivers\wddm_video\vm3d.inf"
    if (Test-Path -Path $WddmFile) {
     
      # Install the WDDM driver and restart the computer.
      pnputil -i -a "$WddmFile"
      restart-computer
	  exit 0
    }
    else {
      write-host "WDDM driver file $WddmFile not found on this computer."
	  exit 1
    }
  }
  else {
    write-host "The WDDM display driver is already installed on this computer."
	exit 0
  }
}
else {
  write-host "This script is only intended for the Microsoft Windows Server 2008 R2 operating system."
  exit 0
}
