[CmdletBinding()]
param([string]$Root = (Get-Location).Path, [string]$EvidencePath = "", [switch]$SkipFrontendInventory)
$ErrorActionPreference = "Stop"
$rootPath = (Resolve-Path $Root).Path
$temp = Join-Path $rootPath "temp"
New-Item -ItemType Directory -Force -Path $temp | Out-Null
$report = Join-Path $temp "senior-monitor-ui-report.txt"
$checks = [System.Collections.Generic.List[string]]::new()
function Add-Check([string]$Name, [bool]$Passed, [string]$Detail) { $checks.Add("[$(if ($Passed) { 'PASS' } else { 'BLOCK' })] $Name - $Detail") }
Add-Check "skill root" (Test-Path (Join-Path $rootPath "SKILL.md")) "root resolved"
Add-Check "component creator" (Test-Path (Join-Path $rootPath "references/component-creator.md")) "shared primitive reference"
if ($EvidencePath) { Add-Check "evidence bundle" (Test-Path (Join-Path $rootPath $EvidencePath)) "requested evidence path" }
if (-not $SkipFrontendInventory) { Add-Check "audit tool" (Test-Path (Join-Path $rootPath "scripts/audit-ui.ps1")) "UI audit availability" }
$checks | Set-Content -Encoding utf8 $report
$blocked = @($checks | Where-Object { $_ -like '[BLOCK]*' })
$decision = if ($blocked.Count) { "BLOCKED" } else { "REVIEW_REQUIRED" }
Add-Content -Encoding utf8 $report "Decision: $decision"
Write-Output "UI Senior Monitor: $decision"
Write-Output "Evidence: $report"
if ($blocked.Count) { exit 2 }
