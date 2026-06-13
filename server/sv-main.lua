RegisterNetEvent("plrs/stress/server/addStress", function(amount)
    local src = source
    local playerJob = Framework.GetPlayerJob(src)
    if Config.IgnoredJobs[playerJob.name] then return end

    Framework.GainStress(src, amount)
end)

RegisterNetEvent("plrs/stress/server/relieveStress", function(amount)
    local src = source

    Framework.RelieveStress(src, amount)
end)