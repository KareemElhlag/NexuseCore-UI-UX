[CmdletBinding()]
param([string]$Root = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$required = @('SKILL.md','README.md','references/quality-gate.md','references/ux-workflow-v2.md','references/performance.md','roles/frontend-architect.md','roles/ux-governance-reviewer.md','roles/ui-platform-engineer.md','scripts/audit-ui.ps1')
$missing = @($required | Where-Object { -not (Test-Path (Join-Path $Root $_)) })
if ($missing.Count -gt 0) { Write-Error ("Missing UI/UX v2 files: " + ($missing -join ', ')); exit 1 }
$skill = Get-Content (Join-Path $Root 'SKILL.md') -Raw
if ($skill -notmatch 'version: "2\.0\.0"') { Write-Error 'SKILL.md is not version 2.0.0'; exit 1 }
if ($skill -notmatch 'v2 role routing') { Write-Error 'v2 role routing is missing'; exit 1 }
$local = @('project.config.json','field-lessons.md') | Where-Object { Test-Path (Join-Path $Root $_) }
if ($local.Count -gt 0) { Write-Error ("Local files must not be in the skill package: " + ($local -join ', ')); exit 1 }
$files = Get-ChildItem -Path $Root -File -Recurse | Where-Object { $_.FullName -notmatch '\\\.git\\|node_modules' }
$text = $files | Get-Content -Raw
foreach ($pattern in @('AKIA[0-9A-Z]{16}','-----BEGIN (RSA|OPENSSH|EC) PRIVATE KEY-----','password\s*[:=]\s*[^<\s]+')) { if ($text -match $pattern) { Write-Error "Potential secret pattern: $pattern"; exit 1 } }
Write-Output 'NEXUSCORE_UI_UX_V2_CHECK=PASS'
Write-Output "REQUIRED_FILES=$($required.Count)"
exit 0
