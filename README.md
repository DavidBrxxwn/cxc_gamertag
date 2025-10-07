# 📝DESCRIPTION
A FiveM script that displays interactive gamertags above players, showing customizable info like name, job, ID, ping, and status, with support for masks, voice chat, and wanted levels. 

# ✨FEATURES
- Debug -- Enables or disables debug mode. If true, debug messages are shown.
- Locale -- Language setting: 'en' English, 'de' German, 'fr' French, 'es' Spanish.
- Framework -- Framework selection: 'qb' for QBCore, 'qbox' for QBox Framework, or 'esx' for ESX.
- System -- Rendering system: 'api' for Rockstar Gamer Tag System or 'draw' for custom DrawText3D.
- KeyToggle -- Enable or disable the key to toggle Gamertag (changeable in FiveM Settings > Key Bindings).
- UpdateInterval -- How often to update gamertag data in milliseconds (e.g., 5000 = 5 seconds).
- IconUpdateInterval -- How often to update icons (mic, wanted stars) in milliseconds (e.g., 500 = 0.5 seconds).
- Visible -- If true, everyone can see my name including myself; if false, only others can see my name but not me.
- Distance -- Maximum distance in units to show gamertags.
- Ping -- Enable or disable ping display in gamertags.
- Job -- Enable or disable job display in gamertags.
- Name -- Enable or disable player name display in gamertags.
- CitizenId -- Enable or disable Citizen ID display in gamertags.
- ServerId -- Enable or disable Server ID display in gamertags.
- Caps -- Convert all text to uppercase/capitals.
- Mask -- Enable or disable mask display.
- MaskComponents -- Multiple component IDs for mask detection (customizable).
- Dead -- Show 'DEAD' text when player has 0 HP.
- PingFormat -- Ping display format: "ms" shows "123ms", "ping" shows "Ping: 123", false shows "123".
- VisibleIcons -- Icon visibility setting: true = everyone sees icons including myself, false = only I see my own icons.
- WantedStarsIcons -- Enable wanted star icons: true = others see my wanted stars (I don't), false = no wanted star icons.
- VisibleWantedStarsIcons -- Wanted star visibility: true = everyone sees them including me, false = only I see my own.
- MicIcons -- Enable microphone icons: true = others see my mic status (I don't), false = no mic icons.
- VisibleMicIcons -- Microphone visibility: true = everyone sees mic status including me, false = only I see my own.
- DrawText3D -- Settings for custom DrawText3D system (scale, font, color, shadow, outline, alignment, etc.).
- ExportGamerTag -- Enable export functions for external resource control.
- ExportGamerTagName -- Export function name (usage: exports['cxc_gamertag']:GamerTag(true/false)).
- ExportDead -- Enable or disable dead export functionality.
- ExportDeadName -- Name of the export function for dead control (usage: exports['cxc_gamertag']:Dead(true/false)).
- ExportMask -- Enable or disable mask export functionality.
- ExportMaskName -- Name of the export function for mask control (usage: exports['cxc_gamertag']:Mask(true/false)).
- Command -- Enable in-game chat command to toggle gamertags.
- CommandOverrideExport -- Command takes priority over export functions when both are enabled.
- CommandName -- Chat command name (players type /gamertag to toggle).
- JobLabelSystem -- Enable or disable job labels system.
- JobLabels -- Customizable job labels with visibility by job or for everyone.

COMMAND:
- "gamertag" on and off

EXPORTS:
- exports['cxc_gamertag']:GamerTag(true/false)
- exports['cxc_gamertag']:Dead(true/false)
- exports['cxc_gamertag']:Mask(true/false)

# 🚨DEPENDENCY 
- qb-core (QBCore): https://github.com/qbcore-framework/qb-core
- qbx_core (Qbox) https://github.com/Qbox-project/qbx_core
- es_extended (ESX): https://github.com/esx-framework/esx_core

# 📚HELPFUL LINKS
- GTAV Mods: https://www.gta5-mods.com/
- GTACars: https://gtacars.net/
- Plebmasters: https://forge.plebmasters.de/

# 🧠FIVEM DOCS
- FiveM Docs: https://docs.fivem.net/docs/
- FiveM Natives: https://docs.fivem.net/natives/
- Controls: https://docs.fivem.net/docs/game-references/controls/
- Blips: https://docs.fivem.net/docs/game-references/blips/
- Checkpoints: https://docs.fivem.net/docs/game-references/checkpoints/
- Markers: https://docs.fivem.net/docs/game-references/markers/
- Ped Models: https://docs.fivem.net/docs/game-references/ped-models/
- Scenarios: https://wiki.rage.mp/wiki/Scenarios
- Vehicle Models: https://docs.fivem.net/docs/game-references/vehicle-references/vehicle-models/
- Vehicle Colours: https://docs.fivem.net/docs/game-references/vehicle-references/vehicle-colours/
- Vehicle Flags: https://docs.fivem.net/docs/game-references/vehicle-references/vehicle-flags/

# 📱SOCIAL MEDIA
- Discord: https://discord.com/invite/PjM3997JnW
- Ko-fi: https://ko-fi.com/cxmmunityclub
- GitHub: https://github.com/DavidBrxxwn

# 🛡️LICENSE
CREATIVE COMMONS BY-NC 4.0 LICENSE

This work is licensed under the Creative Commons BY-NC 4.0 license. This means you are free to use, share, and modify it as long as you give credit to the author (BY) and do not use it for commercial purposes (NC). Sharing under the same license is not required.

