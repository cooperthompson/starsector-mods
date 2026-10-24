# Starsector Mods

My mods for [Starsector](https://fractalsoftworks.com/), plus the Claude Code skills I use to work on them.

## Mods

None yet.

## Install

Copy a folder from `mods/` into `Starsector\mods\`, then enable it in the Starsector launcher.

## Development

```powershell
.\tools\new-mod.ps1 -Id ss_my_mod -Name "My Mod"   # create a mod from the template and link it
.\tools\link-mods.ps1                              # (re)link every mod in mods/ into the game
```

`link-mods.ps1` creates directory junctions from `Starsector\mods\<mod>` to this repo, so the game loads the mods from here and you can edit them in place.

Open this repo (not the game folder) as the editor workspace. Claude Code then loads `CLAUDE.md` and the skills in `.claude/commands/`, and can still read vanilla files from the game install.

Use the in-game console's `devmode`. F8 in the combat simulator reloads ship and weapon data without a restart.

### Mods with code

Data-only mods (ships, weapons, factions, settings) need no build step. When a mod needs Java:

1. Put the source under `mods/<mod>/src/`.
2. Compile it against `Starsector\starsector-core\starfarer.api.jar` (plus `mods\LazyLib\jars\LazyLib.jar` and the like if you use them). The game runs on its bundled Java 17.
3. Write the output jar to `mods/<mod>/jars/` and uncomment `jars` / `modPlugin` in `mod_info.json`.

## Layout

```
mods/                      one folder per mod (folder name = mod id), linked into Starsector\mods\
templates/mod_template/    starting point used by new-mod.ps1
CLAUDE.md                  project notes for Claude Code
.claude/commands/          Claude Code skills
tools/                     helper scripts
```
