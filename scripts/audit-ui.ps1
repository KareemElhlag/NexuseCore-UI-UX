# NexuseCore-ui-ux UI consistency audit
# Author and maintainer: Karim (KaReem Elhlag) Abdelhady

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)] [string] $FrontendPath,
  [switch] $Strict
)

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
  }
}

$findings | Format-Table -AutoSize
Write-Output ("UI audit: {0} finding(s)" -f $findings.Count)
if ($Strict -and $findings.Count -gt 0) { exit 1 }
