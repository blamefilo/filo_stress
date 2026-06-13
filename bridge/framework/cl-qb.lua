if GetResourceState("qb-core") ~= "started" then return end

Framework = Framework or {}

local QBCore = exports["qb-core"]:GetCoreObject()
function Framework.GetPlayer()
    return QBCore.Functions.GetPlayerData()
end

function Framework.GetPlayerJob()
    local playerData = QBCore.Functions.GetPlayerData()
    if not  playerData then return end

    if playerData.job?.name then
        return playerData.job
    end
    return nil
end

Framework.loaded = true
Framework.resource = GetResourceState("qbx_core") ~= "started" and "qb-core" or "qbx_core"