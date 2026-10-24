# Starsector Modding Reference

Game install: `C:\Program Files (x86)\Fractal Softworks\Starsector` (0.98a-RC8, bundled Zulu Java 17 in `jre\`).
Vanilla data: `starsector-core\data`, `starsector-core\graphics`, `starsector-core\sounds` - read-only reference; copy from here, never edit.
Log: `starsector-core\starsector.log` - check it first when the game fails to load a mod (errors name the file and row).
Repo: `C:\Users\cooper\source\repos\starsector-mods` (mods in `mods\`, linked into `Starsector\mods\` by `tools\link-mods.ps1`).

## Mod structure

```
mods/<id>/
  mod_info.json            required; without it the launcher doesn't list the mod
  <id>.version             Version Checker file
  data/
    config/settings.json   game settings overrides (merged)
    config/version/version_files.csv   points Version Checker at <id>.version
    hulls/                 ship_data.csv + *.ship (hull geometry, slots, bounds)
    variants/              *.variant (loadouts); fighters in variants/fighters/
    weapons/               weapon_data.csv + *.wpn + *.proj
    hullmods/              hull_mods.csv
    shipsystems/           ship_systems.csv + *.system
    strings/               descriptions.csv
    world/factions/        *.faction, default_ship_roles.json
    campaign/              rules.csv, special_items.csv, industries.csv, etc.
  graphics/                sprites (ships/, weapons/, missiles/, portraits/, ...)
  sounds/
  jars/                    compiled code, referenced from mod_info "jars"
  src/                     Java source (not loaded by the game)
```

Paths mirror `starsector-core`: a mod file at `data/hulls/ship_data.csv` is combined with the vanilla file at the same path.

## How mod data combines with vanilla

- **CSV**: rows are merged by the `id` column (first column). A mod row with an existing id replaces that row; new ids are added. Only include the rows you change or add, plus the header row.
- **JSON** (settings.json, .faction, .ship, etc.): merged key by key. Arrays are appended, not replaced.
- **To fully replace a vanilla file** instead of merging, list it in mod_info `"replace":["data/..."]`.
- Graphics/sounds at the same path as vanilla override them.

## mod_info.json

Loose JSON: `#` comments and trailing commas are allowed.

```
{
	"id":"ss_example",            # unique across all mods; convention: matches folder
	"name":"Example",
	"author":"Merisai",
	"version":"0.1.0",            # this mod's version
	"description":"...",
	"gameVersion":"0.98a-RC8",
	"jars":["jars/ss_example.jar"],
	"modPlugin":"merisai.ss_example.ModPlugin",   # extends BaseModPlugin
	"dependencies":[{"id":"lw_lazylib","name":"LazyLib"}],
	"replace":[],
	"totalConversion":false,
	"utility":false,              # true = can be added/removed from a save safely
}
```

Enabled mods are stored in `Starsector\mods\enabled_mods.json` by the launcher.

## IDs and naming

Ship, weapon, hullmod, faction, etc. ids share one global namespace across all mods. Prefix everything you add with a short mod prefix (e.g. `ss_` / mod-specific) so it can't collide with vanilla or other mods. Use the vanilla id only when deliberately overriding a vanilla row.

## Code

- Compile against `starsector-core\starfarer.api.jar` (sources/javadoc in `starfarer.api.zip`). Common libs: LazyLib (`lw_lazylib`), MagicLib (`MagicLib`) - add their jars from `Starsector\mods\<lib>\jars\` as compile-only dependencies and declare them in `dependencies`.
- Entry point: a class extending `com.fs.starfarer.api.BaseModPlugin` named in `modPlugin` (`onApplicationLoad`, `onGameLoad`, `onNewGame`, ...).
- Hullmods, ship systems, weapon effects, etc. reference script classes by fully-qualified name from their CSV/JSON.

## Testing

- Console: enable `devmode` (settings.json `"devMode":true` in a mod, or the in-game toggle). F8 in the combat simulator reloads ship and weapon data.
- Adding a non-utility mod to an existing save, or removing one from it, usually breaks the save. Use a fresh game for testing.
