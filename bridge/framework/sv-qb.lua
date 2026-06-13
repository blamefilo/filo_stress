if GetResourceState("qb-core") ~= "started" then return end

Framework = Framework or {}

local QBCore = exports["qb-core"]:GetCoreObject()
function Framework.GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function Framework.GetPlayerJob(source)
    local player = QBCore.Functions.GetPlayer(source)

    if player.PlayerData.job.name then
        return player.PlayerData.job
    end
    return nil
end

function Framework.GainStress(source, amount)
    local player = QBCore.Functions.GetPlayer(source)
    local playerState = Player(source).state
    local newStress

    newStress = player.PlayerData.metadata.stress + amount
    if newStress <= 0 then newStress = 0 end

    if newStress > 100 then
        newStress = 100
    end

    player.Functions.SetMetaData("stress", newStress)
    playerState:set("stress", newStress, true)

    if not Config.Notify then return end
    if newStress == 0 or newStress == 100 then return end
    TriggerClientEvent("ox_lib:notify", source, {
        description = "You're getting stressed.",
        type = "info",
    })
end

function Framework.RelieveStress(source, amount)
    local player = QBCore.Functions.GetPlayer(source)
    local playerState = Player(source).state
    local newStress

    newStress = player.PlayerData.metadata.stress - amount
    if newStress <= 0 then newStress = 0 end

    if newStress > 100 then
        newStress = 100
    end

    player.Functions.SetMetaData("stress", newStress)
    playerState:set("stress", newStress, true)
    if not Config.Notify then return end
    if newStress == 0 or newStress == 100 then return end

    TriggerClientEvent("ox_lib:notify", source, {
        description = "You're feeling better.",
        type = "info",
    })
end

Framework.loaded = true
Framework.resource = GetResourceState("qbx_core") ~= "started" and "qb-core" or "qbx_core"