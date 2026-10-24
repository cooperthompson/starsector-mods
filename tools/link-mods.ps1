# Creates directory junctions so Starsector loads mods straight from this repo.
#   Starsector\mods\<mod>  -> mods\<mod>
# Junctions need no admin rights (Starsector\mods is user-writable; the game root is not). Safe to re-run: existing junctions are skipped.
# Enable each mod in the Starsector launcher afterwards (it writes mods\enabled_mods.json).
param(
    [string]$GameDir = "C:\Program Files (x86)\Fractal Softworks\Starsector"
)

$repo = Split-Path -Parent $PSScriptRoot

function New-Junction($link, $target) {
    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.LinkType -eq "Junction") { Write-Host "ok      $link"; return }
        Write-Warning "skipped $link (a real folder exists there - move it into the repo first)"
        return
    }
    try {
        New-Item -ItemType Junction -Path $link -Target $target -ErrorAction Stop | Out-Null
        Write-Host "linked  $link -> $target"
    } catch {
        Write-Warning "failed  $link : $($_.Exception.Message)"
    }
}

Get-ChildItem (Join-Path $repo "mods") -Directory | ForEach-Object {
    New-Junction (Join-Path $GameDir "mods\$($_.Name)") $_.FullName
}
