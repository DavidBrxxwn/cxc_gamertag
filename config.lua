Config = {}

Config.debug = true

Config.showPing = true
Config.showJob = true
Config.showName = true
Config.showCitizenId = true  -- Show Citizen ID
Config.showServerId = true  -- Show Server ID
Config.uppercaseText = true
Config.mask = true  -- Enable or disable mask display
Config.maskdisplayText = "UNKNOWN"  -- Text to show when a player is wearing a mask
Config.distance = 20
Config.isdead = true  -- Whether to show 'DEAD' text when player has 0 HP
Config.isdeadText = "DEAD"  -- Text to show when player is dead
Config.wanted = true  -- Whether to show the 'Wanted' icon or not
Config.mic = true  -- Whether to show the mic icon or not

-- New config option to control ping display format
Config.pingFormat = "false"  -- Options: "ms", "ping", or "false"

-- Control whether export and command are enabled
Config.export = true  -- Enable or disable export functionality
Config.command = true  -- Enable or disable the 'gamertag' command

Config.job = { -- Non-listed people cannot see the name
    unemployed = "[Unemployed]", 
    police = "[Police]",
    ambulance = "[Medic]",
}
