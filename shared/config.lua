Config = {}

Config.Debug = true -- Enables or disables debug mode. If true, debug messages are shown.
Config.Locale = 'en' -- Language setting: 'en' English, 'de' German, 'fr' French, 'es' Spanish
Config.Framework = 'qb' -- Framework selection: 'qb' for QBCore, 'qbox' for QBox Framework, or 'esx' for ESX

Config.System = 'api' -- Rendering system: 'api' for Rockstar Gamer Tag System or 'draw' for custom DrawText3D
Config.KeyToggle = true -- Enable or disable the key to toggle Gamertag (changeable in FiveM Settings > Key Bindings)

Config.UpdateInterval = 5000 -- How often to update gamertag data in milliseconds (5000 = 5 seconds)
Config.IconUpdateInterval = 500 -- How often to update icons (mic, wanted stars) in milliseconds (500 = 0.5 seconds)
Config.Visible = true -- If true everyone can see my name including myself, if false only others can see my name but not me
Config.Distance = 20 -- Maximum distance in units to show gamertags

Config.Ping = true -- Enable or disable ping display in gamertags
Config.Job = true -- Enable or disable job display in gamertags
Config.Name = true -- Enable or disable player name display in gamertags
Config.CitizenId = false  -- Enable or disable Citizen ID display in gamertags
Config.ServerId = true  -- Enable or disable Server ID display in gamertags
Config.Caps = true -- Convert all text to uppercase/capitals
Config.Mask = false  -- Enable or disable mask display
Config.MaskComponents = {  -- Multiple component IDs for mask detection
    {component = 1, drawable = 0},   -- Face/Mask (standard)
    {component = 0, drawable = 0},   -- Hats/Helmets
    -- {component = 11, drawable = 0},  -- Torso/Jacket (uncomment if needed)
    -- Add more components as needed
}
Config.Dead = true  -- Whether to show 'DEAD' text when player has 0 HP
Config.PingFormat = false  -- Ping display format: "ms" shows "123ms", "ping" shows "Ping: 123", false shows "123"

-- Rockstar Gamer Tag System | works only with System = 'api'
Config.VisibleIcons = true -- Icon visibility setting: true = everyone sees icons including myself, false = only I see my own icons
Config.WantedStarsIcons = true  -- Enable wanted star icons: true = others see my wanted stars (I don't), false = no wanted star icons
Config.VisibleWantedStarsIcons = true --  Wanted star visibility: true = everyone sees them including me, false = only I see my own
Config.MicIcons = true  -- Enable microphone icons: true = others see my mic status (I don't), false = no mic icons
Config.VisibleMicIcons = true --  Microphone visibility: true = everyone sees mic status including me, false = only I see my own

-- DrawText3D System | works only with System = 'draw'
Config.DrawText3D = {
    Scale = 2.0,           -- Base scale multiplier for text size
    Font = 4,              -- Text font style (0-8, different font families)
    TextScale = 0.35,      -- Fine text scale adjustment
    Color = {255, 255, 255, 215}, -- Text color in RGBA format (Red, Green, Blue, Alpha)
    DropShadow = {0, 0, 0, 0, 255}, -- Drop shadow color settings
    Edge = {2, 0, 0, 0, 150}, -- Text outline/edge settings
    UseDropShadow = true,   -- Enable text drop shadow effect
    UseOutline = true,      -- Enable text outline/border
    Centered = true,        -- Center align the text
    Proportional = true     -- Use proportional font spacing
}

-- Export Functions - Allow other resources to control this script
Config.ExportGamerTag = true  -- Enable export functions for external resource control
Config.ExportGamerTagName = "GamerTag"  -- Export function name | Usage: exports['cxc_gamertag']:GamerTag(true/false)

-- Dead Export Settings
Config.ExportDead = true  -- Enable or disable dead export functionality
Config.ExportDeadName = "Dead"  -- Name of the export function for dead control | exports['cxc_gamertag']:Dead(true/false)

-- Mask Export Settings
Config.ExportMask = true  -- Enable or disable mask export functionality
Config.ExportMaskName = "Mask"  -- Name of the export function for mask control | exports['cxc_gamertag']:Mask(true/false)

Config.Command = true  -- Enable in-game chat command to toggle gamertags
Config.CommandOverrideExport = true  -- Command takes priority over export functions when both are enabled
Config.CommandName = "gamertag"  -- Chat command name (players type /gamertag to toggle)

-- Job Label System
Config.JobLabelSystem = true  -- Enable or disable job labels system

-- Format: ["job_name"] = {label = "[DISPLAY_TEXT]", visible_to = {"job1", "job2"} or {"all"}}
-- visible_to: List of jobs that can see this label, or {"all"} for everyone
Config.JobLabels = {
    ["unemployed"] = {
        label = "[UNEMPLOYED]",
        visible_to = {"all"}
    },
    ["police"] = {
        label = "[POLICE]",
        visible_to = {"all"}
    },
    ["ambulance"] = {
        label = "[AMBULANCE]", 
        visible_to = {"all"}
    },
    ["mechanic"] = {
        label = "[MECHANIC]",
        visible_to = {"all"}
    },
}
