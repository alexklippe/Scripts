   [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null 
    $localpath = "D:\elmed\update"
   
    $localSharePath = "\\dsirova.gp2.loc\update"
    $servers = "f3-sql1", "server2.f4.tgp2.ru", "gr-sql2" ,"f1-sql1"
     $backupservers = "gr-sql1","f1-sql","f3-sql1","server2.f4.tgp2.ru"
    $cred = [pscredential]::new('sa',(ConvertTo-SecureString -String '******' -AsPlainText -Force))



#Copy-Item -Path d:\elmed\update\Blgot.bak -Destination "\\sqlserver\forelmed" -Verbose
ForEach ($nServer in $servers)
{
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $nServer

    #Copy-Item -Path d:\elmed\update\Blgot.bak -Destination "\\$server\forelmed" -Verbose
    if (Test-Path "$localpath\blgot.bak"){
    Write-Output "$nServer\blgot.bak"
        $db="blgot"
        try
        {
        write-output "Restore database $db on $nServer to single user"
        Invoke-Sqlcmd -ServerInstance $nserver -Query "use master ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK IMMEDIATE
        "  -Credential $cred -ConnectionTimeout 0 -OutputSqlErrors $true -Verbose
        Invoke-Sqlcmd -ServerInstance $nserver -Query "use master ALTER DATABASE $db SET MULTI_USER WITH ROLLBACK IMMEDIATE" -Credential $cred -OutputSqlErrors $true -Verbose
        
        Restore-SqlDatabase -ServerInstance "$nserver" -Database "$db" -BackupFile "$localsharePath\$db.bak" -Credential $cred -ReplaceDatabase -FileNumber 1 -Verbose
        write-output "Database $db on $nServer restore completed"
  #      Invoke-Sqlcmd -ServerInstance $nserver -Query "" -Credential $cred
        write-output "Changing database $dbname on $nServer to Multi user"
   
        #$dbname.useraccess = "Multiple"
        #$dbname.Alter()
  #      write-output "Database $db on $nServer set to Multi User Successfully"
        }catch{
            write-output "Database $db on $nServer ERROR update"
        }

    }
    if (Test-Path "$localpath\blgot34.bak"){
    Write-Output "$nServer\blgot34.bak"
    $db="blgot34"
    try
    {

      write-output "Restore database $db on $nServer to single user"
        Invoke-Sqlcmd -ServerInstance $nserver -Query "use master ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK IMMEDIATE
            "  -Credential $cred -ConnectionTimeout 0 -OutputSqlErrors $true -verbose
           Invoke-Sqlcmd -ServerInstance $nserver -Query "use master ALTER DATABASE $db SET MULTI_USER WITH ROLLBACK IMMEDIATE" -Credential $cred   -OutputSqlErrors $true -Verbose
           Restore-SqlDatabase -ServerInstance "$nserver" -Database "$db" -BackupFile "$localsharePath\$db.bak" -Credential $cred -ReplaceDatabase -FileNumber 1 -Verbose
           write-output "Changing database $dbname on $nServer to Multi user"
           
        write-output "Database $db on $nServer restore completed"
        
        }catch{
            write-output "Database $dbname on $nServer ERROR update"
        }
    }


}
$date=get-date -format "ddMMyy"
ForEach ($nServer in $backupservers)
{
Write-Output "backup $nServer"
   Backup-SqlDatabase -ServerInstance "$nserver" -Database "lgota" -Credential $cred -BackupFile "$localsharePath\lgota_$nServer $date.bak" -CompressionOption On
    }

    Write-Output "Task completed"
    read-host “Press ENTER to continue...”