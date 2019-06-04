      
$driveArray = New-Object System.Collections.Generic.List[object]
$driveArrayErr = New-Object System.Collections.Generic.List[object]
$computer = hostname
$Path = 
$receversEmailAddress = 
$EmailServer =
    
$drives  = Get-WmiObject Win32_LogicalDisk -ErrorAction Stop | Where-Object {$_.DriveType -eq 3}
    
foreach($drive in $drives)    {
$driveArray.Add([pscustomobject]@{
        Computer        = $computer
        DriveID         = $drive.DeviceID
        TotalSize = [math]::round($drive.Size / 1GB, 2)
        FreeSpace = [math]::round($drive.FreeSpace  / 1GB, 2)
        FreePct   = [math]::round($drive.FreeSpace / $drive.size, 2) * 100                                                                     
        })
}
           
         
    foreach($item in $driveArray)   
    {

    if ($driveArray.FreePct -le 20){
        
    $driveArrayErr.Add([pscustomobject]@{
                    Computer        = $driveArray.Computer
                    DriveID         = $driveArray.DriveID 
                    'TotalSize(GB)' = $driveArray.TotalSize
                    'FreeSpace(GB)' = $driveArray.FreeSpace
                    'FreePct'       = $driveArray.FreePct
                    })
                    }
    }
    
                 
if($driveArrayErr-ne $null)
{
 $driveArray | Export-Csv "$Path"
    
Send-MailMessage -From "senderEmail" -Subject "$computer" -To "$receversEmailAddress" -Attachments "$Path"  -Body "Please Check $computer Server as it has alerted to a harddrive being over 80% full. Please see list Attached"  -SmtpServer $EmailServer

Remove-Item "$Path"
}      


