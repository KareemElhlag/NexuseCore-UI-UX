[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $FrontendPath,
    [string]$EvidencePath = "",
    [switch]$Strict
)

<#
.SYNOPSIS
Mechanical pre-checks for the UX Senior Monitor stage (SKILL.md / SENIOR_MONITOR.md).

.IMPORTANT
Fixed 2026-10-12, same defect class as kmg-agent-skill's own senior-monitor.ps1 (they were reviewed
together): a prior version of this script (a) could only ever emit BLOCKED or REVIEW_REQUIRED, never
CERTIFIED/CERTIFIED_WITH_RESIDUE as SKILL.md told the agent to wait for, and (b) only checked that this
SKILL PACKAGE's own files existed on disk (SKILL.md, references/component-creator.md) - it never looked
at the actual project being reviewed, so a clean run proved nothing about the UI work itself.

This script now actually runs the real audit (scripts/audit-ui.ps1) against -FrontendPath and reports a
MECHANICAL result from its findings. Like the kmg-agent-skill script, this is a prerequisite gate, not
the final decision: the real CERTIFIED / CERTIFIED_WITH_RESIDUE / REWORK_REQUIRED / BLOCKED call still
requires the agent's own judgment against the user-job, data-contract, states, accessibility, RTL, and
browser-evidence criteria in SENIOR_MONITOR.md - none of which a static scan can evaluate.

Also note the naming overlap with kmg-agent-skill's "Senior Monitor": these are two independent
certification stages (engineering vs. UX) that a combined task may both need to pass. They are not
duplicates of each other and neither substitutes for the other - but if only this skill is loaded for a
frontend-only change, this is the only certification gate that runs.
#>

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $PSCommandPath
$rootPath = (Resolve-Path $FrontendPath).Path
$temp = Join-Path $rootPath "temp"
New-Item -ItemType Directory -Force -Path $temp | Out-Null
$report = Join-Path $temp "senior-monitor-ui-report.txt"
$checks = [System.Collections.Generic.List[string]]::new()

function Add-Check([string]$Name, [bool]$Passed, [string]$Detail) {
    $checks.Add("[$(if ($Passed) { 'PASS' } else { 'BLOCK' })] $Name - $Detail")
}

Add-Check "frontend path" (Test-Path $rootPath) "resolved: $rootPath"
Add-Check "src/components/ui" (Test-Path (Join-Path $rootPath "src\components\ui")) "central component policy structure"

$auditScript = Join-Path $scriptDir "audit-ui.ps1"
$findings = @()
if (Test-Path $auditScript) {
    $findings = @(& $auditScript -FrontendPath $rootPath)
    Add-Check "consistency audit ran" $true "$($findings.Count) finding(s) - see $report for the full list"
    $blockingFindingKinds = @('duplicate', 'a11y')
    $blockingFindings = @($findings | Where-Object { $_.Kind -in $blockingFindingKinds })
    Add-Check "no blocking audit findings" ($blockingFindings.Count -eq 0) "$($blockingFindings.Count) duplicate/a11y finding(s) require a decision before certifying"
} else {
    Add-Check "consistency audit available" $false "audit-ui.ps1 not found next to this script"
}

if ($EvidencePath) {
    Add-Check "evidence bundle" (Test-Path (Join-Path $rootPath $EvidencePath)) "requested evidence path"
}

$checks | Set-Content -Encoding utf8 $report
if ($findings.Count -gt 0) {
    Add-Content -Encoding utf8 $report "--- audit-ui.ps1 findings ---"
    ($findings | ForEach-Object { "[$($_.Kind)] $($_.Path): $($_.Detail)" }) | Add-Content -Encoding utf8 $report
}
# -like treats [BLOCK] as a character class, not a literal prefix - see senior-monitor.ps1's note.
$blocked = @($checks | Where-Object { $_.StartsWith('[BLOCK]') })
$mechanicalResult = if ($blocked.Count -gt 0) { "BLOCKED" } else { "MECHANICAL_CHECKS_PASSED" }
Add-Content -Encoding utf8 $report "Mechanical result: $mechanicalResult"
Add-Content -Encoding utf8 $report "This is NOT the UX Senior Monitor decision. Render CERTIFIED / CERTIFIED_WITH_RESIDUE / REWORK_REQUIRED / BLOCKED yourself against SENIOR_MONITOR.md and state it in the closing report."

Write-Output "UX Senior Monitor mechanical pre-check: $mechanicalResult"
Write-Output "Evidence: $report"
if ($Strict -and $blocked.Count -gt 0) { exit 2 }
