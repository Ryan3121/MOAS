#General stuff
{

#Top 10 processes by memory usage
{
echo "Top 10 processes by memory usage - "
get-process | Sort-Object -property ws -descending |select-object -first 10 |Select-Object Name,@{Name='WorkingSet';Expression={[math]::Round($_.WorkingSet/1MB)}}
}

#Top 10 processes by CPU usage
{
echo "Top 10 processes by CPU usage - "
get-process | Sort-Object -property cpu -descending |select-object -first 10
}

#Ram stuff (Run all at once for the Free, Used & Total)
{
#RAM stuff, dont touch
$FreeRAM = Get-Ciminstance Win32_OperatingSystem  | % {$_.FreePhysicalMemory / 1MB} 

$FreeRAM = [math]::Round($FreeRAM,2) 

$TotalRAM = Get-Ciminstance Win32_OperatingSystem | % {$_.TotalVisibleMemorySize / 1MB} 

$TotalRAM = [math]::Round($TotalRAM,2) 

$UsedRAM = $TotalRAM - $FreeRAM  

#RAM stuff
"`n"
echo "Free RAM in GB - "
$FreeRAM 
"`n"
echo "Used RAM in GB - "
$UsedRAM 
"`n"
echo "Total RAM in GB - "
$TotalRAM 
"`n"
}

#CPU load average
{
echo "CPU usage in % - "
Get-WmiObject win32_processor | Measure-Object LoadPercentage -Average | Select Average 
}

#Users currently logged in
 {
echo "Users currently logged in - "
query user /server:$SERVER
}
                         
#Disk usage for all drives, with percentage
{
echo "Disk space - "
gwmi Win32_LogicalDisk -ComputerName localhost -Filter "DriveType=3"| select Name, FileSystem,FreeSpace,BlockSize,Size | % {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_} | Format-Table Name, @{n='FS';e={$_.FileSystem}},@{n='Free, Gb';e={'{0:N2}'-f$_.FreeSpace}}, @{n='Free,%';e={'{0:N2}'-f $_.BlockSize}},@{n='Capacity ,Gb';e={'{0:N3}'-f $_.Size}} -AutoSize
}

#Disk queue (for the C drive but change the C to a D)(Change the sample interval to a higher number to be more accurate)
{
Get-Counter –Counter “\LogicalDisk(C:)\Avg. Disk Queue Length” –SampleInterval 5
}

#Failed log on attempts in the last 24 hours (Big number indicates RDP attack)
{
echo "Failed log on attempts in the last 24 hours (Big number indicates RDP attack) - "
$failLogs = Get-EventLog -LogName Security -InstanceId 4625 -After ((Get-Date).AddDays(-1)) | Select-Object TimeGenerated, Index, InstanceId, @{n='Username';e={$_.ReplacementStrings[5]}} 
$failLogs.count 
}

#Pending windows updates (In an easy to copy format)
{
$msUpdateSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$env:COMPUTERNAME))
$updates = $msUpdateSession.CreateUpdateSearcher().Search("IsInstalled=0").Updates

$silverLightInstalled = Get-WindowsFeature | where { $_.Name.ToLower() -like 'silverlight' }

$pendingUpdates = [System.Collections.ArrayList]@()

$updates | % {

$title = $_.Title

if ($_.Title.ToLower().Contains("silverlight")){
    if($silverLightInstalled){
        $pendingUpdates.Add($title)}
}

else{
        $pendingUpdates.Add($title)
    }
}

$updatesCount = $pendingUpdates.Count

if($updatesCount -gt 0){
    Write-Host "*$updatesCount updates pending for $env:COMPUTERNAME*" -BackgroundColor Black -ForegroundColor Yellow
    $pendingUpdates | % { Write-Host $_}
}

else{
    Write-Host "*No pending updates for $env:COMPUTERNAME*" -BackgroundColor Black -ForegroundColor Green
}
}

#AM resource check (Credit to Josh)
{
echo "The disk space is below in the format of: DriveLetter, FreeSpace, TotalSpace" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Force 

#Loops through each disk and returns the drive letter, free space on said drive letter, and total size. 

$Disks = Get-WmiObject win32_logicaldisk 

ForEach ($Disk in $Disks) 

{ 

    $FreeSpace = $Disk | % {$_.FreeSpace / 1GB} 

    $FreeSpaceRounded = [math]::Round($FreeSpace,2) 

    #Rounds the value to 2 decimal places. 

    $DiskSize = $Disk | % {$_.Size / 1GB}  

    $DriveSizeRounded = [math]::Round($DiskSize,2)  

    #Rounds the value to 2 decimal places. 

     

  #  "$($Disk.DeviceID) $($FreeSpaceRounded)GB, $($DriveSizeRounded)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

    "$($Disk.DeviceID)" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

    "$($FreeSpaceRounded)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

    "$($DriveSizeRounded)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

} 

  

#Adds in a line break. 

Write-Output `n | Out-File $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

  

#Not entirely sure if this is accurate, seems to be  

$CPUPercentage = Get-WmiObject win32_processor | Measure-Object LoadPercentage -Average | Select Average  

echo "The current CPU percentage is:"| Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

$CPUPercentage | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

  

  

$FreeRAM = Get-Ciminstance Win32_OperatingSystem  | % {$_.FreePhysicalMemory / 1MB} 

$FreeRAM = [math]::Round($FreeRAM,2) 

$TotalRAM = Get-Ciminstance Win32_OperatingSystem | % {$_.TotalVisibleMemorySize / 1MB} 

$TotalRAM = [math]::Round($TotalRAM,2) 

$UsedRAM = $TotalRAM - $FreeRAM  

  

            

echo "Total RAM:" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append  

"$($TotalRAM)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append  

echo "Free RAM:" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append  

"$($FreeRAM)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

echo "Used RAM:" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append  

"$($UsedRAM)GB" | Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

  

#Adds in a line break. 

Write-Output `n | Out-File $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 

  

$windowsUpdateObject = New-Object -ComObject Microsoft.Update.AutoUpdate 

$LastInstalledUpdate = $windowsUpdateObject.Results | Select LastInstallationSuccessDate 

Write-Output "Windows Updates last installed:" $LastInstalledUpdate |  Out-File -FilePath $env:USERPROFILE\Desktop\ResourceCheck.txt -Append 
}

#Shutdown reason
{
Get-EventLog -Logname System -Newest 5 -Source "USER32" | Select TimeGenerated,Message -ExpandProperty Message
}

#RDP bang number
{
$failLogs = Get-EventLog -LogName Security -InstanceId 4625 -After ((Get-Date).AddDays(-1)) | Select-Object -like Source Network Address

$failLogs.count 
}

#Checking auto maintenance tasks
{
Get-ScheduledTask | ? {$_.Settings.MaintenanceSettings} | Out-GridView
}

}

#Hyper-V stuff (https://kb.ukfast.net/Hyper-V_powershell)
{
#VM information
{

#This will display all of the VMs running on a hardware node and some basic info on them
{
get-vm
}

#Shows all of the information that powershell can pull from a VM. Make sure that you define the VM or the list will be huge. Also, you need quotes if the VM name has a space in
{
get-vm DC-01 | Select-Object *
}

#This will grab the currently running VM's and sort by uptime
{
get-vm | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryGB";E={$_.MemoryAssigned/1GB}},Status
}

#You can change the sort after the first pipe to "Name" or run this to sort by memory
{
get-vm | where {$_.state -eq 'running'} | select Name,Uptime,@{N="MemoryGB";E={$_.MemoryAssigned/1GB}},Status | sort MemoryGB
}

#This will pull all of the VM's that are currently running and give you a list of how many vCPU they have attached to them.
{
get-vm | where {$_.state -eq 'running'} |Get-VMProcessor
}

#This one will pull all of the VM's that are currently on and display information on the memory
{
(Get-VM *).where({$_.state -eq 'running'}) |
select Computername,VMName,
@{Name="MemAssignedMB";Expression={$_.MemoryAssigned/1mb}},
@{Name="MemDemandMB";Expression={$_.MemoryDemand/1mb}},
@{Name="PctMemUsed";Expression={[math]::Round(($_.MemoryDemand/$_.memoryAssigned)*100,2)}},
MemoryStatus | Sort MemoryStatus,PctMemUsed |
Format-Table -GroupBy MemoryStatus -Property Computername,VMName,Mem*MB,Pct*
}

#You will need VM resource metering enabled for the following command, this one will grab all of the VM's and sort them in a list in descending order of average CPU usage.
{
measure-vm * | sort-object -property avgcpu* -descending
}

#This one if for IOPS on a server, you can run against multiple VM's at once but it makes more sense to run against one VM at a time. It will display all the information and then a concise list of what you need.
{
cls
$VMName  = "DC-01"
enable-VMresourcemetering -VMName $VMName
$VMReport = measure-VM $VMName
$DiskInfo = $VMReport.HardDiskMetrics
write-Host "IOPS info VM $VMName" -ForegroundColor Green
$count = 1
foreach ($Disk in $DiskInfo)
{
Write-Host "Virtual hard disk $count information" -ForegroundColor cyan
$Disk.VirtualHardDisk | fl  *
Write-Host "Normalized IOPS for this virtual hard disk" -ForegroundColor cyan
$Disk
$count = $Count +1
}
}

#This will let you know what the autostart settings are. (Start on boot or start if running) It can be helpful if a client want's to know why their VMs didn't start after a hardware node reboot.
{
Get-VM –VMname * | Select-Object VMname,AutomaticStartAction
}


}

#Controlling VMs
{

#Start a VM
{
start-vm DC-01
}
#Stop a VM
{
stop-vm DC-01
}

}

#Snapshots
{

#This will display the snapshots that are on the hardware node.
{
get-vmsnapshot *
}

#This will display the snapshots for the specific VM.
{
get-vm "DC-01" | get-vmsnapshot
}

#This will display the snapshot called "test"
{
get-vm "DC-01" | get-vmsnapshot -name test*
}

#Remove snapshot, run this without the -whatif at the end if you are happy with the results
{
get-vm "DC-01" | Get-VMSnapshot -Name "test" | Remove-VMSnapshot –whatif
}

}

#VHD/X
{

#This will test the differencing chain and make sure the VHD/X is ok, Replace the "D:\VM Storage" with the path to the VHD/X's
{
get-childitem "D:\VM Storage" | Select Name,@{n="Test";Expression={ Test-VHD $_.fullname}} | sort Test
}

#This is useful if a client has thin provisioning on their solution. It will pull all of the VHD's and give you a table with the size assigned to them, the size they actually take up and the percentage used
{
get-vm -vmname * |Select-Object VMid | Get-VHD |
Format-Table Path,
@{N="size on disk";E={ [math]::round(($_.filesize/1GB), 2)}},
@{N="size in hyper-v";E={$_.size/1GB}},
@{N="pctused";E={ [math]::round(($_.filesize/$_.size)*100,2)}}
}

}

#VM networking
{

#This will display all of the VM's and their IP addresses, Mac addresses and switch name
{
Get-VMNetworkAdapter -VMName * | sort IPAddresses
}

#This one only pulls the IP addresses and seems to be a little quicker
{
Get-VM | Select-Object -ExpandProperty NetworkAdapters | Select-Object VMName,IPAddresses | Format-Table -Auto
}

#Again, replace DC-01 with the name of the VM and this will pull just the IP and Mac address.
{
Get-VMNetworkAdapter -VMName DC-01 | Select -expand IPAddresses
}

#If you only want the running VMs (Remove "| where {$_ -match "^192\."}" if the IP's don't come through but this will display the mac address too. The format is nice for copy and pasting VM IP's
{
get-vm | where { $_.state -eq 'running'} | get-vmnetworkadapter | Select VMName,SwitchName,@{Name="IP";Expression={$_.IPAddresses | where {$_ -match "^192\."}}} | Sort VMName
}

}

#Integration services
{

#Show what services are enabled on a VM
{
Get-VMIntegrationService -VMName "DC-01"
}

#This will check what VMs have the Guest integration service enabled.
{
Get-VM * | Get-VMIntegrationService -Name Guest*
}

#Replace DC-01 with the VM that you want the service enabling on
{
Enable-VMIntegrationService -VMName DC-01 -Name "Guest Service Interface"
}


}

#VM resource metering
{

#Enable resource metering for all VM's with the following command
{
Enable-VMresourcemetering *
}

#Enable for just one machine with 
{
Enable-VMResourceMetering -name DC-01
}

#This will let you know if it has been enabled and on what VM's. You don't get a notification when it is enabled so this is a good way of telling if it was enabled or not.
{
Get-VM | Format-Table Name, State, ResourceMeteringEnabled
}

#By default, it will collect data every hour, this will have a performance hit when it runs and take up disk space if left on for long periods. The frequency can be changed with
{
Set-VMHost -ResourceMeteringSaveInterval 01:30:00
}

#This will show you all of the avaible fields that the resource metering can pull.
{
Get-VM -ComputerName localhost -Name “DC-01” | Measure-VM | Select-Object *
}

#Because resource metering can cause a performance hit and take up disk space, it is a good idea to disable it when you are done. This can be done with this command
{
get-vm "DC-01" | Disable-VMResourceMetering
}

}

#File transfer between VM's
{
Copy-VMFile -VMName DC-01 -SourcePath Documents\test.txt -DestinationPath C:\ -FileSource Host
}

}

#IIS stuff (https://kb.ukfast.net/IIS_powershell)
{

#Site information
{

#This module will allow you to do some really powerful things. You will see what it can do below
{
Import-Module Webadministration
}

#This will pull a list of all sites that have "test" at the start of their name, show you their bindings and the location on the disk.
{
Get-ChildItem -Path IIS:\Sites | Where-Object {$_.Name -match "test*"}
}

#Will show you all of the sites with an SSL. Dropping the s at the end of https will show you all bindings without an SSL and their location on the disk.
{
Get-ChildItem -Path IIS:\Sites | findstr "https"
}

#This will show you a list of all the bindings. No more going through the IIS management GUI and going through each website individually!
{
Get-WebBinding

#Get-WebBinding is also amazing for finding what sites have sni enabled on them. The SSL flags returned have the following meaning and putting everything in an easy to read table.
# sslFlags = 0  Represents  No SNI  (or no SSL installed on the site)
# sslFlags = 1  Represents  SNI Enabled
# sslFlags = 2  Represents Non SNI binding which uses Central Certificate Store.
# sslFlags = 3  Represents  SNI binding which uses Central Certificate store

}

#Adding the | findstr '0.45'to the end will display the bindings for the IP with 0.45 in it.
{
Get-WebBinding | findstr '0.45'
}

#Will show you a nice list of sites and their bindings. Drop the S at the end to show sites without HTTPS bindings.
{
Get-WebBinding | Where-Object {$_.protocol -match "https"}
}

}

#Controlling sites
{

#Will start the website, replace with the site name or use a * to start all of the websites.
{
Start-Website "sitenamehere"
}

#Will stop a website, replace the site name.
{
Stop-Website "sitenamehere"
}

}

#Making a site in Powershell
{

#This may not be used much on support but it's here if you ever need it. This command will fail if the path does not exist yet.
{
New-Website -Name "sitenamehere" -Port 80 -IPAddress "192.168.0.136" -HostHeader "" -PhysicalPath "D:\inetpub\sitenamehere"
}

#This command will create the directory test\test and place the new website in it. Change out test\test with the path to where you want the website going.
{
(mkdir C:\test\test) -and (New-Website -Name "sitenamehere2" -Port 80 -IPAddress "192.168.0.136" -HostHeader "" -PhysicalPath "C:\test\test")
}

}

#Configuration backups
{

#Shows the available config backups
{
Get-WebConfigurationBackup
}

#Will backup the config
{
Backup-WebConfiguration
}

#Will restore the config.
{
Restore-WebConfiguration
}

}

#Getting the header fields
{
$fields = (Get-Content -Path C:\inetpub\logs\LogFiles\W3SVC1\u_ex180109.log -TotalCount 4 | select-string "#Field") -replace '#Fields: ' -split ' '

$logs = Get-Content –Path C:\inetpub\logs\LogFiles\W3SVC1\u_ex180109.log | Select-String -NotMatch -Pattern '^#' | ConvertFrom-Csv -Delimiter ' ' -Header $fields

$logs | Where-object {$_."sc-status" -eq "404"} | Format-table time, cs-method, c-ip, sc-status, cs-uri-stemDave

#Make sure that you change the two "W3SVC1" strings to correspond to the correct log file. Site 2 will be "W3SVC2" and site 99 will be "W3SVC99"
#Make sure that you also change the name of the log files as you probably don't want "u_ex180109.log" but the latest log file found in "C:\inetpub\logs\LogFiles\W3SVC1"
}

#Checking if a site is being compressed
{
(iwr www.ukfast.com -H @{"Accept-Encoding"="gzip"} | select -Exp Headers)."Content-Encoding"
#Replace www.ukfast.com with the site you want to check. This will probably return gzip. The only site I could find in a short search that didn't use compression is www.dotcom-tools.com if you want to compare the outputs.
}

#This is a command that will tell you what site the logs correspond to. You could do this in the GUI just as easily but then you wouldn't be using powershell
{
foreach($WebSite in $(get-website))
{
$logFile="$($Website.logFile.directory)\w3svc$($website.id)".replace("%SystemDrive%",$env:SystemDrive)
Write-host "$($WebSite.name) [$logfile]"
}
}

}

#Exchange stuff (https://kb.ukfast.net/Exchange_Powershell_Commands)
{

#Show the current size of the send limit
{
get-receiveconnector | select identity,maxmessagesize
}

#Increase/Decrease size of send limit
{
set-sendconnector "Connector Name" -maxmessagesize 27MB
}

#Event logs relating to exchange
{
Get-EventLog Application | Where { $_.Source -Ilike “*Exchange*” }
}

#Check when Mailboxes were last backed up (if they ever were)
{
Get-ExchangeServer | Get-MailboxDatabase -Status | Format-Table Name, *Back*
}

#Move all mailboxes from one database to another
{
Get-MailboxDatabase| Get-Mailbox | Move-Mailbox -TargetDatabase
}

#Check effective permissions on a mailbox
{
Get-Mailbox | Get-MailboxPermission -User
}

#Get size of mailbox and number of items in it
{
get-mailboxstatistics -identity name
}

#See what certificate Exchange is using
{
Get-ExchangeCertificate
}

#Check Databases Active ( "Mounted" ) and Database Copies ( "Healthy/Failed/Suspended" )
{
get-mailboxserver | get-mailboxdatabasecopystatus
}

#Check for any mail queues e.g. for queue sizes > 5
{
get-transportservice | get-queue | ?{$_.Identity -notlike "*\Shadow\*"} | ?{$_.MessageCount -gt 5}
}

#Check if Services Down - all ok if fields "ServicesNotRunning" all show blank - if not restart them on appropriate server
{
get-exchangeserver | test-servicehealth
}

#List exchange mailboxes (Does not include dist groups)
{
foreach($mailbox in $mbs) {
  $maddresses = @($mailbox.EmailAddresses | where {$_.SmtpAddress -notmatch "ukfastexchange.co.uk$"})
   "{0,-20}{1}" -f $mailbox.DisplayName, $maddresses[0].SmtpAddress
   foreach($alias in $maddresses[1..$maddresses.Length]) {
     "{0,-20}{1}" -f "", $alias.SmtpAddress
   }
}
}

#Extract message tracking logs for a domain using Exchange 2007
{
get-messagetrackinglog -EventID "SEND" -Start "18/08/2010 13:31:00" -End "18/08/2011 13:41:00"
-ResultSize "Unlimited"| where{$_.sender -like "*@example.com"} | select-object Sender,TimeStamp,MessageSubject,@{Name=
"Recipients";Expression={$_.recipients}} | export-csv D:\output\output.csv
}


}

#MSSQL Stuff (WIP...)
{
#Check the failed logons for user accounts (Tested in PS4 2012R2, event id might need changing for other versions)
{
$DATE = [DateTime]::Now.AddDays(-1)

$EVS = Get-EventLog Application -InstanceId 3221243928 -after $DATE

$EVS | select-string -inputobject {$_.message} -pattern "CLIENT:(.)*\.*\.*\.*"  -allmatches | foreach-object {$_.Matches} | foreach-object {$_.Value} | foreach-object {$_.replace("Source Network Address:", "")} | group-object -property $_ | where-object {$_.count -gt 1} | select-object -property name, count | format-list -descending

}


} 
