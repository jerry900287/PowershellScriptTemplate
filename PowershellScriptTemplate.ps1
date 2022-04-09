#==== Function for writing log ====
Function Write-Log {
    param (
        [string]$logString = "",
        [string]$logPath = "$($logFolder)\$($logFile)"
    )
    Write-Host "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss') | $($logString)" 
    Write-Output "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss') | $($logString)" | Out-File -FilePath $logPath -Append
}
#===================================

#==== Function for removing item ====
Function Delete-File{
    param (
        [string]$path = "$($logFolder)",
        [int]$reservedQuantity = 30,
        [string]$mode = "Count"
    )
    
    if ($mode -eq "Count"){
        $reservedFiles = Get-ChildItem -Path $path | Select-Object -ExpandProperty Name -last $reservedQuantity
        Get-ChildItem -Path $path -Exclude $reservedFiles | Remove-Item -Force -ErrorAction SilentlyContinue
    }

    if ($mode -eq "Day"){
        $reservedFiles = Get-ChildItem -Path $path | Where-Object {$_.LastWriteTime -lt $(Get-Date).AddDays(-($reservedQuantity))}
        $reservedFiles | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}
#===================================

#==== Initial Log Setting ====
$projectName = "Test"
$logFolder = "D:\Testing"
$logFile = "$(Get-Date -f yyyyMMdd-HHmmss)_$($projectName).log" 
$logReservedQuantity = 5
$logReservedMode = "Count"

if (!(Test-Path $logFolder)){
    New-Item -ItemType directory -Path $logFolder
}

Delete-File -Path $logFolder -ReservedQuantity $logReservedQuantity -Mode $logReservedMode
#===================================

Write-Log "Hello World"

