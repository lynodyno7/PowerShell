#Parameters

$logFile = "C:\DiskClean_Log\DiskCleanupLog25.txt" # Log File for recording cleanup details
$folderToClean = @(
    "$env:temp", # Temporary files folder (User-Specific)
    "C:\Windows\Temp" # Windows Temp Folder (System-wide)

)

$recybleBin = "$env:SystemDrive\$Recycle.Bin" # Path to Recycle Bin

#Function to Clean Specified Folders

function Clean-Folder {
    param (
        [string]$folderPath
    )

        if (Test-Path $folderPath) {
            $files = Get-ChildItem -Path $folderPath -Recurse -Force -ErrorAction SilentlyContinue
            $totalSize = 0


            foreach ($item in $items) {
                try {
                    $totalSize += $item.Length
                    Remove-Item -Path $item.FullName -Force -Recurse -ErrorAction SilentlyContinue
                
                } catch {
                    Write-Warning "Failed to delete $($item.FullName): $_"
                }
            
            }

            $sizeInMB = [math]::Round($totalSize / 1MB, 2)
            Write-Host "Emptied Recycle Bin: Freed $sizeInMB MB" -ForegroundColor Cyan
            "Emptied Recycle Bin: Freed $sizeInMB" | Out-File -FilePath $logFile -Append
    
    } else {
        Write-Warning "Recycle Bin not found."
    
    }
}

#Main Script Execution

Write-Host "Starting Disk Cleanup..." -ForegroundColor Yellow
"Disk Cleanup Started: $(Get-Date)" | Out-File -FilePath $logFile -Append



#Clean Specified folders

foreach ($folder in $folderToClean) {
    Clean-Folder -folderPath $folder

}

# Empty the recycle bin
Clear-RecycleBin

#Completion Message
Write-Host "Disk Cleanup Completed!" -ForegroundColor Green
"Disk Cleanup Completed: $(Get-Date)" | Out-File $logFile -Append