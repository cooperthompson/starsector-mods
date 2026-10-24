# Starsector modding

This is the `starsector-mods` repo (remote github.com/cooperthompson/starsector-mods). Each folder in `mods/` is linked into the game by a directory junction at `C:\Program Files (x86)\Fractal Softworks\Starsector\mods\<mod>`, so the game loads mods straight from here.

- The user is Cooper (Steam/mod author name: Merisai). They have modded X4 extensively and are comfortable with XML/data modding; Starsector is new to them.
- Cooper's own mods use the folder name = mod id, prefixed `ss_`. Create new ones with `tools\new-mod.ps1` so they get linked into the game.
- Mods that aren't Cooper's (e.g. "ThirstSector Portraits v1.44") are real folders in `Starsector\mods\`, not part of the repo. Don't edit them; override their files from one of Cooper's mods instead.
- Never edit `Starsector\starsector-core` - it's vanilla game data and gets overwritten by updates. Read it for reference and copy what you need into a mod. The game root is admin-protected anyway; only `Starsector\mods\` is writable.
- See the `starsector-modding` skill for file formats and conventions.
