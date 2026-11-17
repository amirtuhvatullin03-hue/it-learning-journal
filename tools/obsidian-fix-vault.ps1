$root = Split-Path -Parent $PSScriptRoot
$reg = Join-Path $env:APPDATA "obsidian\obsidian.json"

Get-Process Obsidian -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Ключ в реестре произвольный — Obsidian читает значение "path".
$entry = New-Object System.Collections.Hashtable
$entry.path = $root
$entry.ts = [int64]([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())
$entry.open = $true
$vaults = New-Object System.Collections.Hashtable
$vaults."ac5ade306a59baae" = $entry
$rootObj = New-Object System.Collections.Hashtable
$rootObj.vaults = $vaults
[System.IO.File]::WriteAllText($reg, (ConvertTo-Json $rootObj -Depth 5 -Compress), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "registry -> $root"

Start-Process "D:\programs\Obsidian\Obsidian.exe"
Start-Sleep -Seconds 14

$w = (Get-Process Obsidian -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle } | Select-Object -First 1).MainWindowTitle
Write-Host "WINDOW: $w"

# workspace проекта: открывать дашборд Home.md
$wsPath = Join-Path $root ".obsidian\workspace.json"
if (Test-Path $wsPath) {
  try {
    $ws = [System.IO.File]::ReadAllText($wsPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
    if ($ws.PSObject.Properties.Name -contains "active") { $ws.active = "Home" }
    if ($ws.PSObject.Properties.Name -contains "lastOpenFiles") { $ws.lastOpenFiles = @("Home") }
    [System.IO.File]::WriteAllText($wsPath, ($ws | ConvertTo-Json -Depth 30), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "workspace.json: active=Home"
  } catch { Write-Host "workspace: $($_.Exception.Message)" }
}
