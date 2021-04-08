<#PSScriptInfo
 
.VERSION 1.0000000001
 
.GUID 5611f619-14cf-4f85-863a-1b097337e397
 
.AUTHOR Ryan
 
.COMPANYNAME
 
.COPYRIGHT
 
.TAGS
 
.LICENSEURI
http://31.193.1.107/api/v2/package

.PROJECTURI
http://31.193.1.107/api/v2/package

.ICONURI
http://31.193.1.107/api/v2/package

.EXTERNALMODULEDEPENDENCIES
 
.REQUIREDSCRIPTS
 
.EXTERNALSCRIPTDEPENDENCIES
 
.RELEASENOTES
 
#>
 
<#
 
.DESCRIPTION
Not done yet, hit me up with suggestions :)
 
#>


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '982,740'
$Form.text                       = "Hyper-VMOASGUI"
$Form.TopMost                    = $false
$Form.BackColor = "lightgreen"


$Button1                         = New-Object system.Windows.Forms.Button

$Button1.text                    = "Get VM snapshots"
$Button1.width                   = 130
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(8,8)
$Button1.Font                    = 'Microsoft Sans Serif,10'
$Button1.Add_Click({
      
              $Results.text =  get-vmsnapshot * | ft -AutoSize | Out-String

      })


$Results                        = New-Object system.Windows.Forms.TextBox
$Results.width                  = 966
$Results.height                 = 500
$Results.location               = New-Object System.Drawing.Point(9,228)
$Results.Font                   = "Lucida Console,10"
$Results.Multiline = $true
$Results.WordWrap =$false
$Results.Scrollbars = "Both"
$Results.Font = "Lucida Console,10"


$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $true
$TextBox2.width                  = 514
$TextBox2.height                 = 210
$TextBox2.location               = New-Object System.Drawing.Point(461,12)
$TextBox2.Scrollbars = "Both"
$TextBox2.Font                   = "Lucida Console,10"

         #$Results.TextBox2 =  "a"
$ctaa =  get-vm | where {$_.state -eq 'running'} | sort Uptime  | select Name, CPU*,@{N="MemoryGB";E={$_.MemoryAssigned/1GB}}, uptime | ft -autosize | Out-String

$TextBox2.Appendtext("{0}`n" -f "$ctaa")


$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Enable guest intergration"
$Button2.width                   = 166
$Button2.height                  = 30
$Button2.location                = New-Object System.Drawing.Point(8,49)
$Button2.Font                    = 'Microsoft Sans Serif,10'
$Button2.Add_Click({
        
        [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
        $vmname1 = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a VM name, * for all VM's", "$env:vmname1")


        Enable-VMIntegrationService -VMName $vmname1 -Name "Guest Service Interface" 
        
        $Results.text =  "Done!"
        

})

Enable-VMIntegrationService -VMName DC-01 -Name "Guest Service Interface"

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "Check integration services"
$Button3.width                   = 180
$Button3.height                  = 30
$Button3.location                = New-Object System.Drawing.Point(8,88)
$Button3.Font                    = 'Microsoft Sans Serif,10'
$Button3.Add_Click({
        
        [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
        $vmname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a VM name", "$env:vmname")


        $Results.text =  Get-VMIntegrationService -VMName $vmname | ft -AutoSize | Out-String

})

$Button4                         = New-Object system.Windows.Forms.Button
$Button4.text                    = "VM IP`'s"
$Button4.width                   = 61
$Button4.height                  = 30
$Button4.location                = New-Object System.Drawing.Point(8,127)
$Button4.Font                    = 'Microsoft Sans Serif,10'
$Button4.Add_Click({
        

        $Results.text =  Get-VM | where {$_.state -eq 'running'} | Select-Object -ExpandProperty NetworkAdapters | Select-Object VMName,IPAddresses | Format-Table -Auto | Out-String

})

$Button5                         = New-Object system.Windows.Forms.Button
$Button5.text                    = "Get all info"
$Button5.width                   = 80
$Button5.height                  = 30
$Button5.location                = New-Object System.Drawing.Point(145,8)
$Button5.Font                    = 'Microsoft Sans Serif,10'
$Button5.Add_Click({
        
        [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
        $vmname2 = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a VM name", "$env:vmname2")


        $Results.text =  get-vm -vmname $vmname2 | Select-Object * | Out-String

})

$Button6                         = New-Object system.Windows.Forms.Button
$Button6.text                    = "Disk use"
$Button6.width                   = 80
$Button6.height                  = 30
$Button6.location                = New-Object System.Drawing.Point(180,49)
$Button6.Font                    = 'Microsoft Sans Serif,10'
$Button6.Add_Click({
         $Results.text =  "Shows the size on the disk, size in Hyper-V and the percentage it is using. Very useful for thin provisioned disks  - "

       $zzba = 

get-vm -vmname * |Select-Object VMid | Get-VHD |
Format-Table Path,
@{N="size on disk";E={ [math]::round(($_.filesize/1GB), 2)}},
@{N="size in hyper-v";E={$_.size/1GB}},
@{N="pctused";E={ [math]::round(($_.filesize/$_.size)*100,2)}} | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zzba)
})


$Button7                         = New-Object system.Windows.Forms.Button
$Button7.text                    = "Sort by CPU usage"
$Button7.width                   = 138
$Button7.height                  = 30
$Button7.location                = New-Object System.Drawing.Point(9,170)
$Button7.Font                    = 'Microsoft Sans Serif,10'
$Button7.Add_Click({
         $Results.text =  "Running VM's sorted by how much CPU they are using -"

       $zaaa =   get-vm | where {$_.state -eq 'running'} | select Name,CPUUsage,@{N="MemoryGB";E={$_.MemoryAssigned/1GB}},Uptime | sort CPUUsage -Descending | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zaaa)
})

$Button8                         = New-Object system.Windows.Forms.Button
$Button8.text                    = "Sort by RAM assigned "
$Button8.width                   = 160
$Button8.height                  = 30
$Button8.location                = New-Object System.Drawing.Point(157,170)
$Button8.Font                    = 'Microsoft Sans Serif,10'
$Button8.Add_Click({
         $Results.text =  "Running VM's sorted by how much RAM they have assigned - "

       $zzaa =  get-vm | where {$_.state -eq 'running'} | select Name,@{N="MemoryGB";E={$_.MemoryAssigned/1GB}},Uptime,Status | sort MemoryGB -Descending | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zzaa)
})

$Button9                         = New-Object system.Windows.Forms.Button
$Button9.text                    = "Show assigned vCPU"
$Button9.width                   = 152
$Button9.height                  = 30
$Button9.location                = New-Object System.Drawing.Point(217,129)
$Button9.Font                    = 'Microsoft Sans Serif,10'
$Button9.Add_Click({
         $Results.text =  "Assigned vCPU - "

       $zzza =  get-vm | where {$_.state -eq 'running'} |Get-VMProcessor | sort-object -property count -descending  | Out-String



$Results.Appendtext("{0}`n" -f $zzza)
})

$Button10                        = New-Object system.Windows.Forms.Button
$Button10.text                   = "Show RAM demand"
$Button10.width                  = 147
$Button10.height                 = 30
$Button10.location               = New-Object System.Drawing.Point(192,88)
$Button10.Font                   = 'Microsoft Sans Serif,10'
$Button10.Add_Click({
         $Results.text =  "Memory demand for all running VM's - "

  $zzz =  
       (Get-VM *).where({$_.state -eq 'running'}) |
       select Computername,VMName,
       @{Name="MemAssignedMB";Expression={$_.MemoryAssigned/1mb}},
       @{Name="MemDemandMB";Expression={$_.MemoryDemand/1mb}},
       @{Name="PctMemUsed";Expression={[math]::Round(($_.MemoryDemand/$_.memoryAssigned)*100,2)}},
       MemoryStatus | Sort MemoryStatus,PctMemUsed |
       Format-Table -GroupBy MemoryStatus -Property Computername,VMName,Mem*MB,Pct* | Out-String


$Results.Appendtext("{0}`n" -f $zzz)
})


$Button11                        = New-Object system.Windows.Forms.Button
$Button11.text                   = "Auto start settings"
$Button11.width                  = 130
$Button11.height                 = 30
$Button11.location               = New-Object System.Drawing.Point(80,128)
$Button11.Font                   = 'Microsoft Sans Serif,10'
$Button11.Add_Click({
         $Results.text =  "Auto start settings - "

       $zzzz =  Get-VM –VMname * | Select-Object VMname,AutomaticStartAction | sort AutomaticStartAction -Descending | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zzzz)
})



$Form.controls.AddRange(@($Button1,$Results,$Button2,$Button3,$Button4,$TextBox2,$Button5,$Button6,$Button7,$Button8,$Button9,$Button10,$Button11))




#Write your logic code here

[void]$Form.ShowDialog()


Get-VMIntegrationService -VMName "DC-01"