$env:COMPUTERNAME
Write-host "NETWORK INTERFACES" -ForegroundColor Blue -BackgroundColor White
Get-NetIPAddress | Format-Table

Write-host "PROCESSOR" -ForegroundColor Blue -BackgroundColor White
Get-WmiObject -Class Win32_Processor | Format-Table Name, Number*

Write-host "RAM" -ForegroundColor Blue -BackgroundColor White
Get-WmiObject win32_physicalmemory | Format-Table Manufacturer,Banklabel,Configuredclockspeed,Devicelocator,Capacity -autosize

Write-host "DISKS" -ForegroundColor Blue -BackgroundColor White
Get-PSDrive | Format-Table
cmd /c pause | out-null
