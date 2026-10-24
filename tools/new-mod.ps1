# Creates a new mod from templates\mod_template and links it into the game.
#   .\tools\new-mod.ps1 -Id ss_better_salvage -Name "Better Salvage"
# The folder name matches the id.
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9_]+$')][string]$Id,
    [Parameter(Mandatory)][string]$Name,
    [string]$GameDir = "C:\Program Files (x86)\Fractal Softworks\Starsector"
)

$repo = Split-Path -Parent $PSScriptRoot
$dest = Join-Path $repo "mods\$Id"
if (Test-Path $dest) { throw "$dest already exists" }

Copy-Item (Join-Path $repo "templates\mod_template") $dest -Recurse

Get-ChildItem $dest -Recurse -File | ForEach-Object {
    $text = [IO.File]::ReadAllText($_.FullName)
    $text = $text.Replace("__MOD_ID__", $Id).Replace("__MOD_NAME__", $Name)
    [IO.File]::WriteAllText($_.FullName, $text)
    if ($_.Name -like "*__MOD_ID__*") { Rename-Item $_.FullName ($_.Name.Replace("__MOD_ID__", $Id)) }
}

Write-Host "created $dest"
& (Join-Path $PSScriptRoot "link-mods.ps1") -GameDir $GameDir
