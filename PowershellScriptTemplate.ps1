chcp 437
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
        [int]$remainingQuantity = 30,
        [string]$mode = "Count"
    )
    
    if ($mode -eq "Count"){
        $remainingFiles = Get-ChildItem -Path $path | Select-Object -ExpandProperty Name -last $remainingQuantity
        Get-ChildItem -Path $path -Exclude $remainingFiles | Remove-Item -Force -ErrorAction SilentlyContinue
    }

    if ($mode -eq "Day"){
        $remainingFiles = Get-ChildItem -Path $path | Where-Object {$_.LastWriteTime -lt $(Get-Date).AddDays(-($remainingQuantity))}
        $remainingFiles | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}
#===================================

#==== Initial Log Setting ====
$projectName = "Test"
$logFolder = "D:\Testing"
$logFile = "$(Get-Date -f yyyyMMdd-HHmmss)_$($projectName).log" 
$logRemainingQuantity = 5
$logRemainingMode = "Count"

if (!(Test-Path $logFolder)){
    New-Item -ItemType directory -Path $logFolder
}

Delete-File -Path $logFolder -ReservedQuantity $logRemainingQuantity -Mode $logRemainingMode
#===================================

#==== Initial Script Setting ====
$sessionUser = Query user | Where-Object {$_ -match "Active"}
$sessionActiveID = $sessionUser.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)[2]
$messageShowerFile = "$($PSScriptRoot)\MessageShower.exe"
#===================================

#==== Script Region ====
& "$($PSScriptRoot)\PsExec.exe" /accepteula /d /i $($sessionActiveID) "$($PSScriptRoot)\MessageShower.exe" "-m" "Info" "-t" "System Info" "-z" "213" "-e" "123"

Write-Log "Hello World"

