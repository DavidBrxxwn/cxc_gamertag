local QBCore, ESX, QBox = nil, nil, nil
local hudVisible = true
local playersData = {}
local activeGamerTags = {}
local commandDisabled = false

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

local function RemoveGamerTag(playerId)
    if activeGamerTags[playerId] then
        if Config.System == 'api' then
            RemoveMpGamerTag(activeGamerTags[playerId])
        end
        activeGamerTags[playerId] = nil
    end
end

if Config.KeyToggle then
    RegisterKeyMapping('toggle_gamertag', 'Toggle Gamertag Visibility', 'keyboard', 'F5')
    
    RegisterCommand('toggle_gamertag', function()
        hudVisible = not hudVisible
        if Config.CommandOverrideExport then
            commandDisabled = not hudVisible
        end
        if Config.Debug then
            print(hudVisible and _('hud_enabled') or _('hud_disabled'))
        end
        
        if not hudVisible then
            for playerId in pairs(activeGamerTags) do
                RemoveGamerTag(playerId)
            end
        end
    end, false)
end

local function IsPlayerWearingMask(playerPed)
    for _, maskData in pairs(Config.MaskComponents) do
        local drawable = GetPedDrawableVariation(playerPed, maskData.component)
        if drawable ~= maskData.drawable then
            return true
        end
    end
    return false
end

local function IsJobVisibleTo(targetJob, viewerJob)
    if not Config.UseJobLabels then
        return false
    end
    
    local jobConfig = Config.JobLabels[targetJob]
    if not jobConfig or not jobConfig.visible_to then
        return true
    end
    
    for _, allowedJob in pairs(jobConfig.visible_to) do
        if allowedJob == "all" or allowedJob == viewerJob then
            return true
        end
    end
    
    return false
end

local function DrawText3D(coords, text, scale, font)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z, 1)
    
    if onScreen then
        local scale = (1 / dist) * scale
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov
        
        SetTextScale(0.0 * scale, Config.DrawText3D.TextScale * scale)
        SetTextFont(font or Config.DrawText3D.Font)
        SetTextProportional(Config.DrawText3D.Proportional and 1 or 0)
        SetTextColour(Config.DrawText3D.Color[1], Config.DrawText3D.Color[2], Config.DrawText3D.Color[3], Config.DrawText3D.Color[4])
        
        if Config.DrawText3D.UseDropShadow then
            SetTextDropshadow(Config.DrawText3D.DropShadow[1], Config.DrawText3D.DropShadow[2], Config.DrawText3D.DropShadow[3], Config.DrawText3D.DropShadow[4], Config.DrawText3D.DropShadow[5])
            SetTextDropShadow()
        end
        
        SetTextEdge(Config.DrawText3D.Edge[1], Config.DrawText3D.Edge[2], Config.DrawText3D.Edge[3], Config.DrawText3D.Edge[4], Config.DrawText3D.Edge[5])
        
        if Config.DrawText3D.UseOutline then
            SetTextOutline()
        end
        
        SetTextEntry("STRING")
        SetTextCentre(Config.DrawText3D.Centered and 1 or 0)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function GetPlayerDisplayText(playerData)
    local displayText = ""
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerData.serverid))

    if Config.Dead and GetEntityHealth(playerPed) <= 0 then
        displayText = _('dead_text')
    else
        if Config.Mask and playerData.isMasked then
            displayText = _('mask_text')
        else
            if Config.CitizenId then
                displayText = "[" .. playerData.citizenid .. "] "
            end
            if Config.ServerId then
                displayText = displayText .. "[" .. playerData.serverid .. "] "
            end
            if Config.Job and Config.UseJobLabels then
                local viewerId = PlayerId()
                local viewerServerId = GetPlayerServerId(viewerId)
                local viewerJob = "unemployed"
                
                if playersData[viewerServerId] and playersData[viewerServerId].job then
                    viewerJob = playersData[viewerServerId].job
                end
                
                if IsJobVisibleTo(playerData.job, viewerJob) then
                    local jobConfig = Config.JobLabels[playerData.job]
                    local jobLabel = (jobConfig and jobConfig.label) or playerData.job
                    
                    displayText = displayText .. jobLabel
                end
            elseif Config.Job and not Config.UseJobLabels then
                displayText = displayText .. playerData.job
            end
            if Config.Name then
                displayText = displayText .. " " .. playerData.name
            end

            if Config.Ping and playerData.ping then
                if Config.PingFormat == "ms" then
                    displayText = displayText .. " " .. _('ping', playerData.ping)
                elseif Config.PingFormat == "ping" then
                    displayText = displayText .. " " .. _('ping_format', playerData.ping)
                elseif Config.PingFormat == false or Config.PingFormat == "false" then
                    displayText = displayText .. " " .. playerData.ping
                end
            end
        end
    end

    return Config.Caps and string.upper(displayText) or displayText
end

local function DisplayGamerTag(playerPed, playerData)
    local displayText = GetPlayerDisplayText(playerData)
    
    local isOwnPlayer = GetPlayerFromServerId(playerData.serverid) == PlayerId()
    local shouldShow = true
    
    if not Config.Visible and isOwnPlayer then
        shouldShow = false
    end
    
    if not shouldShow then
        RemoveGamerTag(playerData.serverid)
        return
    end
    
    if Config.System == 'api' then
        if not activeGamerTags[playerData.serverid] then
            local gamerTag = CreateMpGamerTag(playerPed, displayText, false, false, "", 0)
            activeGamerTags[playerData.serverid] = gamerTag
            
            SetMpGamerTagVisibility(gamerTag, 4, true)
        else
            SetMpGamerTagName(activeGamerTags[playerData.serverid], displayText)
        end

        local showMicIcon = false
        if Config.MicIcons then
            local isSpeaking = NetworkIsPlayerTalking(GetPlayerFromServerId(playerData.serverid))
            local isOwnPlayer = GetPlayerFromServerId(playerData.serverid) == PlayerId()
            
            if Config.VisibleIcons then
                if Config.VisibleMicIcons then
                    showMicIcon = isSpeaking
                else
                    showMicIcon = isOwnPlayer and isSpeaking
                end
            else
                showMicIcon = isOwnPlayer and isSpeaking
            end
        end
        
        if Config.MicIcons then
            SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 4, showMicIcon)
        else
            SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 4, false)
        end

        local showWantedIcon = false
        if Config.WantedStarsIcons then
            local wantedLevel = GetPlayerWantedLevel(GetPlayerFromServerId(playerData.serverid))
            local isWanted = (wantedLevel > 0)
            local isOwnPlayer = GetPlayerFromServerId(playerData.serverid) == PlayerId()
            
            if Config.VisibleIcons then
                if Config.VisibleWantedStarsIcons then
                    showWantedIcon = isWanted
                else
                    showWantedIcon = isOwnPlayer and isWanted
                end
            else
                showWantedIcon = isOwnPlayer and isWanted
            end
        end
        
        if Config.WantedStarsIcons then
            SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 7, showWantedIcon)
        else
            SetMpGamerTagVisibility(activeGamerTags[playerData.serverid], 7, false)
        end
        
    elseif Config.System == 'draw' then
        activeGamerTags[playerData.serverid] = {
            ped = playerPed,
            text = displayText,
            serverid = playerData.serverid
        }
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

                    if distance <= Config.Distance then
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

RegisterNetEvent('updatePlayerData')
AddEventHandler('updatePlayerData', function(updatedData)
    if type(updatedData) == 'table' then
        playersData = updatedData
    else
        if Config.Debug then
            print(_('error_invalid_data'))
        end
    end
end)

if Config.ExportGamerTag then
    exports(Config.ExportGamerTagName, function(enable)
        if Config.CommandOverrideExport and commandDisabled and enable then
            if Config.Debug then
                print('Export blocked: Command has disabled gamertags')
            end
            return
        end
        
        hudVisible = enable
        if Config.Debug then
            print('GamerTag ' .. (enable and 'enabled' or 'disabled') .. ' via export')
        end
        
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

if Config.Command then
    RegisterCommand(Config.CommandName, function()
        hudVisible = not hudVisible
        if Config.CommandOverrideExport then
            commandDisabled = not hudVisible
        end
        print(hudVisible and _('hud_enabled') or _('hud_disabled'))
        if not hudVisible then
            for playerId in pairs(activeGamerTags) do
                RemoveGamerTag(playerId)
            end
        end
    end, false)
end



if Config.ExportGamerTag and Config.ExportDead then
    exports(Config.ExportDeadName, function(enable)
        Config.Dead = enable
        if Config.Debug then
            print('Dead display ' .. (enable and 'enabled' or 'disabled') .. ' via export')
        end
    end)
    

end

if Config.ExportGamerTag and Config.ExportMask then
    exports(Config.ExportMaskName, function(enable)
        Config.Mask = enable
        if Config.Debug then
            print('Mask display ' .. (enable and 'enabled' or 'disabled') .. ' via export')
        end
    end)
end

if Config.ExportGamerTag and Config.ExportJobLabels then
    exports(Config.ExportJobLabelsName, function(enable)
        Config.UseJobLabels = enable
        if Config.Debug then
            print('Job Labels ' .. (enable and 'enabled' or 'disabled') .. ' via export')
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.IconUpdateInterval)
        
        if hudVisible and Config.System == 'api' then
            for serverId, gamerTag in pairs(activeGamerTags) do
                if gamerTag and type(gamerTag) == "number" then
                    local playerFromServerId = GetPlayerFromServerId(serverId)
                    
                    if playerFromServerId and playerFromServerId ~= -1 then
                        if Config.MicIcons then
                            local isSpeaking = NetworkIsPlayerTalking(playerFromServerId)
                            local isOwnPlayer = playerFromServerId == PlayerId()
                            local showMicIcon = false
                            
                            if Config.VisibleIcons then
                                if Config.VisibleMicIcons then
                                    showMicIcon = isSpeaking
                                else
                                    showMicIcon = isOwnPlayer and isSpeaking
                                end
                            else
                                showMicIcon = isOwnPlayer and isSpeaking
                            end
                            
                            SetMpGamerTagVisibility(gamerTag, 4, showMicIcon)
                        end
                        
                        if Config.WantedStarsIcons then
                            local wantedLevel = GetPlayerWantedLevel(playerFromServerId)
                            local isWanted = (wantedLevel > 0)
                            local isOwnPlayer = playerFromServerId == PlayerId()
                            local showWantedIcon = false
                            
                            if Config.VisibleIcons then
                                if Config.VisibleWantedStarsIcons then
                                    showWantedIcon = isWanted
                                else
                                    showWantedIcon = isOwnPlayer and isWanted
                                end
                            else
                                showWantedIcon = isOwnPlayer and isWanted
                            end
                            
                            SetMpGamerTagVisibility(gamerTag, 7, showWantedIcon)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local wasPaused = false
    while true do
        Citizen.Wait(1000)
        
        local isPaused = IsPauseMenuActive()
        
        if wasPaused and not isPaused and hudVisible then
            if Config.Debug then
                print('Pause menu closed, restoring gamer tags...')
            end
            
            Citizen.Wait(1000)
            
            if Config.System == 'api' then
                for playerId in pairs(activeGamerTags) do
                    RemoveGamerTag(playerId)
                end
                
                for _, playerData in pairs(playersData) do
                    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerData.serverid))
                    if playerPed and DoesEntityExist(playerPed) then
                        local playerCoords = GetEntityCoords(playerPed)
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, myCoords.x, myCoords.y, myCoords.z)
                        
                        if distance <= Config.Distance then
                            DisplayGamerTag(playerPed, playerData)
                        end
                    end
                end
            end
            
            if Config.Debug then
                print('Gamer tags restored after pause menu')
            end
        end
        
        wasPaused = isPaused
    end
end)

if Config.System == 'draw' then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            
            if hudVisible then
                for serverId, tagData in pairs(activeGamerTags) do
                    if tagData.ped and DoesEntityExist(tagData.ped) then
                        local coords = GetEntityCoords(tagData.ped)
                        local headCoords = GetPedBoneCoords(tagData.ped, 12844, 0.0, 0.0, 0.3)
                        
                        DrawText3D(headCoords, tagData.text, Config.DrawText3D.Scale, Config.DrawText3D.Font)
                    end
                end
            end
        end
    end)
end

local function CleanupGamerTags()
    if Config.System == 'api' then
        for playerId, gamerTag in pairs(activeGamerTags) do
            if gamerTag then
                RemoveMpGamerTag(gamerTag)
                if Config.Debug then
                    print('Removed gamer tag for player: ' .. playerId)
                end
            end
        end
    end
    activeGamerTags = {}
    if Config.Debug then
        print('All gamer tags cleaned up')
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if Config.Debug then
            print('Resource stopping, cleaning up gamer tags...')
        end
        CleanupGamerTags()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if Config.Debug then
            print('Resource starting, initializing clean state...')
        end
        CleanupGamerTags()
        InitializeFramework()
    end
end)
