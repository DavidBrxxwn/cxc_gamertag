local QBCore, ESX, QBox = nil, nil, nil

local function InitializeFramework()
    if Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
        if Config.Debug then
            print(_('framework_loaded', 'QBCore'))
        end
    elseif Config.Framework == 'qbox' then
        QBox = exports.qbx_core
        if Config.Debug then
            print(_('framework_loaded', 'QBox'))
        end
    elseif Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        if Config.Debug then
            print(_('framework_loaded', 'ESX'))
        end
    else
        if Config.Debug then
            print(_('framework_error', Config.Framework))
        end
    end
end

Citizen.CreateThread(function()
    InitializeFramework()
end)

local function GetPlayerData(src)
    if Config.Framework == 'qb' and QBCore then
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            return {
                citizenid = player.PlayerData.citizenid,
                serverid = src,
                name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                job = player.PlayerData.job.name,
                ping = GetPlayerPing(src),
                isMasked = false
            }
        end
    elseif Config.Framework == 'qbox' and QBox then
        local player = QBox:GetPlayer(src)
        if player then
            return {
                citizenid = player.PlayerData.citizenid,
                serverid = src,
                name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                job = player.PlayerData.job.name,
                ping = GetPlayerPing(src),
                isMasked = false
            }
        end
    elseif Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return {
                citizenid = xPlayer.identifier,
                serverid = src,
                name = xPlayer.getName(),
                job = xPlayer.job.name,
                ping = GetPlayerPing(src),
                isMasked = false
            }
        end
    end
    return nil
end

RegisterServerEvent('requestPlayerData')
AddEventHandler('requestPlayerData', function()
    local src = source
    local allPlayersData = {}
    
    for _, playerId in ipairs(GetPlayers()) do
        local playerData = GetPlayerData(tonumber(playerId))
        if playerData then
            allPlayersData[tonumber(playerId)] = playerData
        end
    end
    
    if next(allPlayersData) then
        TriggerClientEvent('updatePlayerData', src, allPlayersData)
    elseif Config.Debug then
        print(_('no_player_data_available'))
    end
end)

