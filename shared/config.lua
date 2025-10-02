Config = {}

Config.debug = true  -- Enables or disables debug mode

Config.showPing = true  -- Displays the player's ping
Config.showJob = true  -- Displays the player's current job
Config.showName = true  -- Displays the player's name
Config.showCitizenId = true  -- Displays the player's Citizen ID
Config.showServerId = true  -- Displays the player's Server ID
Config.uppercaseText = true  -- Converts text to uppercase
Config.mask = true  -- Enables or disables mask display
Config.maskdisplayText = "UNKNOWN"  -- Text displayed when a player is wearing a mask
Config.distance = 20  -- Maximum distance at which information is displayed
Config.isdead = true  -- Displays the "DEAD" text when a player has 0 HP
Config.isdeadText = "DEAD"  -- Text displayed when a player is dead
Config.wanted = true  -- Displays the "Wanted" icon if active
Config.mic = true  -- Displays the microphone icon if active
Config.pingFormat = "false"  -- Format of the ping display: "ms", "ping", or "false"

-- Controls whether export and command functionalities are enabled
Config.export = true  -- Enables or disables export functionality
Config.command = true  -- Enables or disables the "gamertag" command

-- Determines which jobs can see names (Unlisted jobs cannot see names)
Config.job = {
    unemployed = "[Unemployed]",
    police = "[Police]",
    ambulance = "[Medic]",
}
