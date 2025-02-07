local QBCore = exports['qb-core']:GetCoreObject()
local hudVisible = true
local playersData = {}
local activeGamerTags = {}

local function IsPlayerWearingMask(playerPed)
    local maskDrawable = GetPedDrawableVariation(playerPed, 1)
    return maskDrawable ~= 0
end

local function GetPlayerDisplayText(playerData)
    local displayText = ""
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerData.serverid))

    if Config.isdead and GetEntityHealth(playerPed) <= 0 then
        displayText = Config.isdeadText
    else
        if Config.mask and playerData.isMasked then
            displayText = Config.maskdisplayText
        else
            if Config.showCitizenId then
                displayText = "[" .. playerData.citizenid .. "] "
            end
            if Config.showServerId then
                displayText = displayText .. "[" .. playerData.serverid .. "] "
            end
            if Config.showJob then
                local jobLabel = Config.job[playerData.job] or playerData.job
                displayText = displayText .. jobLabel
            end
            if Config.showName then
                displayText = displayText .. " " .. playerData.name
            end

            if Config.showPing and playerData.ping then
                if Config.pingFormat == "ms" then
                    displayText = displayText .. " " .. string.format("%02dms", playerData.ping)
                elseif Config.pingFormat == "ping" then
                    displayText = displayText .. " ping: " .. playerData.ping
                elseif Config.pingFormat == "false" then
                    displayText = displayText .. " " .. playerData.ping
                end
            end
        end
    end

    return Config.uppercaseText and string.upper(displayText) or displayText
end

local function DisplayGamerTag(playerPed, playerData)
    local displayText = GetPlayerDisplayText(playerData)

    if not activeGamerTags[playerData.serverid] then
        local gamerTag = CreateMpGamerTag(playerPed, displayText, false, false, "", 0)
        activeGamerTags[playerData.serverid] = gamerTag
    else
        SetMpGamerTagName(activeGamerTags[playerData.serverid], displayText)
    end

    if Config.mic then
        local isSpeaking = NetworkIsPlayerTalking(GetPlayerFromServerId(playerData.serverid))
        SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 4, isSpeaking)
    else
        SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 4, false)
    end

    if Config.wanted then
        local wantedLevel = GetPlayerWantedLevel(GetPlayerFromServerId(playerData.serverid))
        local isWanted = (wantedLevel > 0)
        SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 7, isWanted)
    else
        SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 7, false)
    end
end

local function UpdatePlayerData()
    for playerId, playerData in pairs(playersData) do
        local playerPed = GetPlayerPed(GetPlayerFromServerId(playerData.serverid))

        if playerPed and DoesEntityExist(playerPed) then
            local playerCoords = GetEntityCoords(playerPed)
            local isWithinDistance = false

            for _, otherPlayerData in pairs(playersData) do
                local otherPlayerPed = GetPlayerPed(GetPlayerFromServerId(otherPlayerData.serverid))
                if otherPlayerPed and DoesEntityExist(otherPlayerPed) then
                    local otherPlayerCoords = GetEntityCoords(otherPlayerPed)
                    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, otherPlayerCoords.x, otherPlayerCoords.y, otherPlayerCoords.z)

                    if distance <= Config.distance then
                        isWithinDistance = true
                        break
                    end
                end
            end

            if isWithinDistance then
                if playerData.ping then
                    DisplayGamerTag(playerPed, playerData)
                end

                playerData.isMasked = IsPlayerWearingMask(playerPed)
            else
                RemoveGamerTag(playerData.serverid)
            end
        else
            RemoveGamerTag(playerData.serverid)
        end
    end
end

local function RemoveGamerTag(playerId)
    if activeGamerTags[playerId] then
        RemoveMpGamerTag(activeGamerTags[playerId])
        activeGamerTags[playerId] = nil
    end
end

RegisterNetEvent('updatePlayerData')
AddEventHandler('updatePlayerData', function(updatedData)
    if type(updatedData) == 'table' then
        playersData = updatedData
    else
        print("Error: Invalid data received")
    end
end)

if Config.export then
    exports('DisplayGamerTag', function(enable)
        hudVisible = enable
        if not hudVisible then
            for playerId in pairs(activeGamerTags) do
                RemoveGamerTag(playerId)
            end
        else
            for _, playerData in pairs(playersData) do
                local playerPed = GetPlayerPed(GetPlayerFromServerId(playerData.serverid))
                if playerPed and DoesEntityExist(playerPed) then
                    DisplayGamerTag(playerPed, playerData)
                end
            end
        end
    end)
end

if Config.command then
    RegisterCommand('gamertag', function()
        hudVisible = not hudVisible
        print(hudVisible and "HUD enabled" or "HUD disabled")
        if not hudVisible then
            for playerId in pairs(activeGamerTags) do
                RemoveGamerTag(playerId)
            end
        end
    end, false)
end

if Config.export then
    exports('DisplayGamerTag', function()
        hudVisible = not hudVisible
        if not hudVisible then
            for playerId, gamerTag in pairs(activeGamerTags) do
                SetMpGamerTagVisibility(gamerTag, 0, false)
            end
        else
            for playerId, gamerTag in pairs(activeGamerTags) do
                SetMpGamerTagVisibility(gamerTag, 0, true)
            end
        end
    end)
end

Citizen.CreateThread(function()
    TriggerServerEvent('requestPlayerData')
    while true do
        Wait(5000)
        TriggerServerEvent('requestPlayerData')
    end
end)

Citizen.CreateThread(function()
    while true do
        if hudVisible then
            UpdatePlayerData()
        end
        Wait(500)
    end
end)