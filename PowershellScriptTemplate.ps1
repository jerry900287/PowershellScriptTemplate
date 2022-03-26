#Initial Setting
$fileName = "Test"
$logFolder = "D:\Testing"
$logFile = "$(Get-Date -f yyyyMMdd-HHmmss)_$($fileName).log" 
$logReservedQuantity = 5

if (!(Test-Path $logFolder)){
    New-Item -ItemType directory -Path $logFolder
}

Write-Log "Hi"

Delete-File -Path $logFolder -ReservedQuantity $logReservedQuantity

Function Write-Log {
    param (
        [string]$logString = "",
        [string]$logPath = "$($logFolder)\$($logFile)"
    )
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss') | $($logString)" 
    Write-Output "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss') | $($logString)" | Out-File -FilePath $logPath -Append
}
Function Delete-File{
    param (
        [string]$path = "$($logFolder)",
        [int]$reservedQuantity = $logReservedQuantity
    )
    
    $reservedFiles = Get-ChildItem -Path $logFolder | Select-Object -ExcludeProperty Name -last $reservedQuantity
    Get-ChildItem -Path $logFolder -Exclude $reservedFiles | Remove-Item -Force -ErrorAction SilentlyContinue
}