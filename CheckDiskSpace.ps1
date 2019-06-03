    #Gets a list of the local harddrives. Drive tyep 3 is for local hard drive
    $Drive = Get-wmiObject -class win32_logicalDisk | Where-Object {$_.DriveType -eq 3} 

    #Gets the server name
    $comuterName = Hostname

    #if the $drive array is not null is creata a hash table and put the details into it.
    if($Drive -ne $null)
    {
    $hash = @{
                'ComputerName' = $comuterName;
                'DriveId' = $Drive.DeviceID;
                'FreeSpace' = ([math]::Round($Drive.FreeSpace/1GB,2));
                'Size' = ([math]::Round($Drive.Size/1GB,2)); 
                'PercentFree' = (($Drive.FreeSpace/$Drive.Size)*100);
    }} 

    # If $hash is not null chak the percent free and it less than 20% add it to $send Hash table
    If ($hash -ne $null)
    {
    foreach ($item in $hash)
    {
            If ($hash.PercentFree -le 20)
    {
    $Send = @{
                'ComputerName' = $comuterName;
                'DriveId' = $hash.DeviceID;
                'FreeSpace' = $hash.FreeSpace;
                'Size' = $Drive.Size; 
                'PercentFree' = $hash.PercentFree;
    }
    }}}
    
    # If the $send has table is not null convert it to PScustomeobject and export it to csv.
    if($send -ne $null)
    {
    $results = [pscustomobject]$Send
    $results | Export-Csv -Path C:\WorkingFolder\drivedetails.cvs

    }
   
