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

$Results                        = New-Object system.Windows.Forms.TextBox
$Results.multiline              = $false
$Results.width                  = 1131
$Results.height                 = 770
$Results.location               = New-Object System.Drawing.Point(9,153)
$Results.Font = "Lucida Console,10"
$Results.Multiline = $true
$Results.WordWrap =$false
$Results.Scrollbars = "Both"

$IISMOASv1                       = New-Object system.Windows.Forms.Form
$IISMOASv1.ClientSize            = '1155,934'
$IISMOASv1.text                  = "Form"
$IISMOASv1.TopMost               = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Site ID`'s"
$Button1.width                   = 64
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(5,44)
$Button1.Font                    = 'Microsoft Sans Serif,10'
$Button1.Add_Click({
         $Results.text =  "Site ID's by friendly names  - "

       $zzba = Get-ChildItem -Path IIS:\Sites | select Name, ID | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zzba)
})

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Import webadmin module"
$Button2.width                   = 188
$Button2.height                  = 30
$Button2.location                = New-Object System.Drawing.Point(5,8)
$Button2.Font                    = 'Microsoft Sans Serif,10'
$Button2.Add_Click({

Import-Module Webadministration

$Results.text =  "Done!"

})


$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "Find SSL bindings"
$Button3.width                   = 142
$Button3.height                  = 30
$Button3.location                = New-Object System.Drawing.Point(5,81)
$Button3.Font                    = 'Microsoft Sans Serif,10'
$Button3.Add_Click({
         $Results.text =  "Sites with SSL bindings  - "

       $zzaba = Get-WebBinding | Where-Object {$_.protocol -match "https"} | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $zzaba)
})

$Button4                         = New-Object system.Windows.Forms.Button
$Button4.text                    = "Find non-SSL bindings"
$Button4.width                   = 172
$Button4.height                  = 30
$Button4.location                = New-Object System.Drawing.Point(158,81)
$Button4.Font                    = 'Microsoft Sans Serif,10'
$Button4.Add_Click({
         $Results.text =  "Sites with non-SSL bindings  -  `r`n" 
         
       $fzaba = Get-ChildItem -Path IIS:\Sites | findstr "http"| ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $fzaba)
})

$Button5                         = New-Object system.Windows.Forms.Button
$Button5.text                    = "Get all bindings"
$Button5.width                   = 131
$Button5.height                  = 30
$Button5.location                = New-Object System.Drawing.Point(73,44)
$Button5.Font                    = 'Microsoft Sans Serif,10'
$Button5.Add_Click({
         $Results.text =  "All bindings  - "

       $qzaba = Get-WebBinding | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $qzaba)
})

$Button6                         = New-Object system.Windows.Forms.Button
$Button6.text                    = "Bindings by IP address"
$Button6.width                   = 186
$Button6.height                  = 30
$Button6.location                = New-Object System.Drawing.Point(211,44)
$Button6.Font                    = 'Microsoft Sans Serif,10'
$Button6.Add_Click({
         $Results.text =  "Bindings for the IP  -  `r`n"


                  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                  $IPisthis = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an IP on this server", "$env:IPisthis")

       $aqzaba = Get-WebBinding | findstr $IPisthis | ft -AutoSize | Out-String



$Results.Appendtext("{0}`n" -f $aqzaba)
})

$Button7                         = New-Object system.Windows.Forms.Button
$Button7.text                    = "Start site/s"
$Button7.width                   = 87
$Button7.height                  = 30
$Button7.location                = New-Object System.Drawing.Point(202,8)
$Button7.Font                    = 'Microsoft Sans Serif,10'
$Button7.Add_Click({
                  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                  $Sitenametostart = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an site to start, * for all", "$env:Sitenametostart")

    
       start-website -name $Sitenametostart

                $Results.text =  "Site/s started!"
})

$Button8                         = New-Object system.Windows.Forms.Button
$Button8.text                    = "Stop site/s"
$Button8.width                   = 91
$Button8.height                  = 30
$Button8.location                = New-Object System.Drawing.Point(299,8)
$Button8.Font                    = 'Microsoft Sans Serif,10'
$Button8.Add_Click({
                  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                  $Sitenametostop = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an site to stop, * for all", "$env:Sitenametostop")

    
       stop-website $Sitenametostop

                $Results.text =  "Site/s stopped!"
})

$Button9                         = New-Object system.Windows.Forms.Button
$Button9.text                    = "Show config backups"
$Button9.width                   = 153
$Button9.height                  = 30
$Button9.location                = New-Object System.Drawing.Point(397,8)
$Button9.Font                    = 'Microsoft Sans Serif,10'
$Button9.Add_Click({
         $Results.text =  "Config backups  - "

       $zzabr = Get-WebConfigurationBackup | ft -AutoSize | Out-String

$Results.Appendtext("{0}`n" -f $zzabr)
})

$Button10                        = New-Object system.Windows.Forms.Button
$Button10.text                   = "Back up config"
$Button10.width                  = 118
$Button10.height                 = 30
$Button10.location               = New-Object System.Drawing.Point(406,44)
$Button10.Font                   = 'Microsoft Sans Serif,10'
$Button10.Add_Click({
         $Results.text =  "Dont use this yet"
         
         #"Config backed up! "

       #$zzhha = Backup-WebConfiguration | Out-String



#$Results.Appendtext("{0}`n" -f $zzhha)
})

$Button11                        = New-Object system.Windows.Forms.Button
$Button11.text                   = "Restore config"
$Button11.width                  = 115
$Button11.height                 = 30
$Button11.location               = New-Object System.Drawing.Point(557,8)
$Button11.Font                   = 'Microsoft Sans Serif,10'

$Button12                        = New-Object system.Windows.Forms.Button
$Button12.text                   = "Get responses from logs"
$Button12.width                  = 180
$Button12.height                 = 30
$Button12.location               = New-Object System.Drawing.Point(339,81)
$Button12.Font                   = 'Microsoft Sans Serif,10'

$Button13                        = New-Object system.Windows.Forms.Button
$Button13.text                   = "Count responses from logs"
$Button13.width                  = 183
$Button13.height                 = 30
$Button13.location               = New-Object System.Drawing.Point(529,81)
$Button13.Font                   = 'Microsoft Sans Serif,10'
$Button13.Add_Click({
                  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                  $loglocationyo = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the log location (use the show log location button)", "$env:loglocationyo")

                  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
                  $logresponseyo = [Microsoft.VisualBasic.Interaction]::InputBox("What response are you looking for?", "$env:logresponseyo")
    
    $logresponseyo
    $loglocationyo + "[datetime]::Today.ToString('yyMMdd')
    $loglocationyo + "[datetime]::Today.ToString('yyMMdd')

    u_ex191004.log


    $loglocationyo | where-object {$_.scstatus -eq $logresponseyo} | Measure-Object 

                $Results.text =  
                
                $loglocationyo | where-object {$_.scstatus -eq $logresponseyo} | Measure-Object | ft -AutoSize | Out-String
})


$Button14                        = New-Object system.Windows.Forms.Button
$Button14.text                   = "Count bot hits in logs"
$Button14.width                  = 146
$Button14.height                 = 30
$Button14.location               = New-Object System.Drawing.Point(532,44)
$Button14.Font                   = 'Microsoft Sans Serif,10'

$Button15                        = New-Object system.Windows.Forms.Button
$Button15.text                   = "Show log location"
$Button15.width                  = 123
$Button15.height                 = 30
$Button15.location               = New-Object System.Drawing.Point(679,9)
$Button15.Font                   = 'Microsoft Sans Serif,10'
$Button15.Add_Click({
         $Results.text = " "

$asdasda =

    foreach($WebSite in $(get-website))
    {
    $logFile="$($Website.logFile.directory)\w3svc$($website.id)".replace("%SystemDrive%",$env:SystemDrive)
    "$($WebSite.name) [$logfile]" | ft -AutoSize | Out-String
    } 

$Results.Appendtext($asdasda)
})

$IISMOASv1.controls.AddRange(@($Button1,$Button2,$Results,$Button3,$Button4,$Button5,$Button6,$Button7,$Button8,$Button9,$Button10,$Button11,$Button12,$Button13,$Button14,$Button15))




#Write your logic code here

[void]$IISMOASv1.ShowDialog()