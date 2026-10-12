# NexuseCore-ui-ux UI consistency audit
# Author and maintainer: Karim (KaReem Elhlag) Abdelhady

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)] [string] $FrontendPath,
  [switch] $Strict,
  [string] $ReportCsv = ""
)

<#
.NOTES
Fixed 2026-10-12: the previous version piped $findings through Format-Table before emitting anything,
which converts each row into a formatting object and truncates long paths with no way to get the real
data back out - callers had to wrap the whole script in `Out-String -Width 600` just to read a full
path, and could never consume $findings programmatically (filter it, diff it against a prior run, feed
it to another check). This version returns the real [pscustomobject] collection on the pipeline (so
`./audit-ui.ps1 ... | Where-Object Kind -eq token` works), writes an optional full-fidelity CSV via
-ReportCsv, and prints a readable, non-truncated table to the host for a human running it directly.
#>

$ErrorActionPreference = "Stop"
$root = (Resolve-Path $FrontendPath).Path
$src = Join-Path $root "src"
$ui = Join-Path $src "components\ui"
$findings = [System.Collections.Generic.List[object]]::new()

function Add-Finding([string]$kind, [string]$path, [string]$detail) {
  $findings.Add([pscustomobject]@{ Kind = $kind; Path = $path; Detail = $detail })
}

if (-not (Test-Path $ui)) { Add-Finding "structure" $ui "Missing src/components/ui" }
else {
  $canonicalNames = Get-ChildItem $ui -File -Include *.tsx,*.ts | ForEach-Object { $_.BaseName }
  $featureFiles = Get-ChildItem $src -Recurse -File -Include *.tsx,*.ts | Where-Object { $_.FullName -notlike "$ui*" }
  foreach ($file in $featureFiles) {
    $text = Get-Content $file.FullName -Raw
    foreach ($name in $canonicalNames) {
      if ($name -in @('index','utils')) { continue }
      if ($text -match "(function|const|class)\s+$([regex]::Escape($name))(\s|=|\()") {
        Add-Finding "duplicate" $file.FullName "Feature defines a local $name; compose the canonical ui component."
      }
    }
    if ($text -match 'animate-\[|@keyframes|animation\s*:' -and $text -notmatch 'prefers-reduced-motion|motion-reduce') {
      Add-Finding "motion" $file.FullName "Custom motion has no visible reduced-motion handling."
    }
    if ($file.FullName -like '*\src\features\*' -and $text -match '#[0-9a-fA-F]{3,8}\b' -and $file.FullName -notlike '*.test.*') {
      Add-Finding "token" $file.FullName "Hard-coded color found outside theme/token files."
    }
    # A dialog/modal that never traps focus lets Tab escape to the page behind it - a real
    # accessibility defect this script previously never checked for at all.
    if ($text -match '<Dialog|<Modal|role=["'']dialog["'']' -and $text -notmatch 'trapFocus|FocusTrap|focus-trap|useFocusTrap') {
      Add-Finding "a11y" $file.FullName "Dialog/modal markup found with no focus-trap usage nearby; confirm Tab cannot escape to the page behind it."
    }
  }
}

if ($ReportCsv) {
  $csvPath = if ([System.IO.Path]::IsPathRooted($ReportCsv)) { $ReportCsv } else { Join-Path $root $ReportCsv }
  $findings | Export-Csv -NoTypeInformation -Encoding utf8 -Path $csvPath
  Write-Host "Full-fidelity findings written to: $csvPath"
}

if ($findings.Count -gt 0) {
  $findings | Format-Table -AutoSize -Wrap | Out-String -Width 500 | Write-Host
}
# Human-readable summary goes to the host stream, never the success/output stream - a caller that
# captures this script's output (e.g. @(& ./audit-ui.ps1 ...)) must get ONLY the finding objects
# below, not this string mixed into the same collection.
Write-Host ("UI audit: {0} finding(s)" -f $findings.Count)
if ($Strict -and $findings.Count -gt 0) { exit 1 }

# Return the real objects on the pipeline so a caller can filter/consume them programmatically
# instead of only seeing the console table above.
$findings
