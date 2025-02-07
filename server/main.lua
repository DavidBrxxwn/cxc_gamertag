local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('requestPlayerData')
AddEventHandler('requestPlayerData', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        local playerData = {
            [src] = {
                citizenid = player.PlayerData.citizenid,
                serverid = src,
                name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                job = player.PlayerData.job.name,
                ping = GetPlayerPing(src),
                isMasked = falsE
            }
        }
        TriggerClientEvent('updatePlayerData', src, playerData)
    end
end)

