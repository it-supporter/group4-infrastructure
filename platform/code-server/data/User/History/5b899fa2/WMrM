
# Sample PowerShell Infrastructure Script
# Used for testing VS Code syntax highlighting

param(
    [string]$ComputerName = "localhost",
    [switch]$VerboseOutput
)

function Get-SystemInformation {
    [CmdletBinding()]
    param(
        [string]$Target
    )

    try {
        Write-Host "Collecting information from $Target..." -ForegroundColor Cyan

        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Target
        $cpu = Get-CimInstance -ClassName Win32_Processor -ComputerName $Target
        $memoryGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)

        [PSCustomObject]@{
            ComputerName = $Target
            OS           = $os.Caption
            Version      = $os.Version
            CPU          = $cpu.Name
            MemoryGB     = $memoryGB
            LastBoot     = $os.LastBootUpTime
        }
    }
    catch {
        Write-Warning "Failed to query $Target"
        Write-Error $_.Exception.Message
    }
}

$servers = @(
    "dc01",
    "monitor01",
    "automation01",
    "platform01"
)

$results = foreach ($server in $servers) {
    Get-SystemInformation -Target $server
}

$results |
    Sort-Object ComputerName |
    Format-Table -AutoSize

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$results |
    Export-Csv `
        -Path ".\reports\system-report-$timestamp.csv" `
        -NoTypeInformation `
        -Encoding UTF8

if ($VerboseOutput) {
    Write-Verbose "Report generated successfully." -Verbose
}

Write-Host "Completed." -ForegroundColor Green