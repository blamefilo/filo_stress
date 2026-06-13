local inVehicle = false

local function currentStressLevel()
    return LocalPlayer.state.stress or 0
end

local function getBlurTimeout()
    local stressLevel = currentStressLevel()
    for _, v in pairs(Config.ScreenEffect.blur) do
        if stressLevel >= v.min and stressLevel <= v.max then
            return v.timeout
        end
    end
end

local function getEffectInterval()
    local stressLevel = currentStressLevel()
    for _, v in pairs(Config.ScreenEffect.interval) do
        if stressLevel >= v.min and stressLevel <= v.max then
            return v.timeout
        end
    end
end

local function startStressThread()
    if not Config.Enabled then return end
    local lastSprintStress = 0
    local lastVehicleHealth = math.huge
    local lastEffectTimeout = 0
    while true do
        local ped = cache.ped or PlayerPedId()
        local totalStress = 0

        if Config.IgnoredJobs[Framework.GetPlayerJob().name] then
            Wait(5000)
        else
            if IsPedSprinting(ped) and GetGameTimer() - lastSprintStress > 60 * 1000 then
                local stressToAdd = Config.StressGain.running
                if type(stressToAdd) == "table" then
                    stressToAdd = math.random(stressToAdd.min, stressToAdd.max)
                end

                totalStress += stressToAdd
                lastSprintStress = GetGameTimer()
            end

            if cache.vehicle and GetVehicleBodyHealth(cache.vehicle) < lastVehicleHealth then
                lastVehicleHealth = GetVehicleBodyHealth(cache.vehicle)
                local stressToAdd = Config.StressGain.crash
                if type(stressToAdd) == "table" then
                    stressToAdd = math.random(stressToAdd.min, stressToAdd.max)
                end

                totalStress += stressToAdd
            end

            -- Screen Effects
            local effectTimeout = getEffectInterval()
            if effectTimeout then
                if GetGameTimer() - lastEffectTimeout > effectTimeout then
                    local blurTimeout = getBlurTimeout()
                    lastEffectTimeout = GetGameTimer()

                    if blurTimeout then
                        TriggerScreenblurFadeIn(1000.0)
                        CreateThread(function()
                            Wait(blurTimeout)
                            TriggerScreenblurFadeOut(1000.0)
                        end)
                    end

                    if currentStressLevel() >= Config.ScreenEffect.shakeStart then
                        lib.playAnim(cache.ped, "random@homelandsecurity", "knees_loop_girl", nil, nil, 1000, 49)
                        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.08)
                    end
                end
            end


            if totalStress > 0 then
                TriggerServerEvent("plrs/stress/server/addStress", totalStress)
            end
            Wait(100)
        end
    end
end

local function startVehicleThread()
    if not Config.Enabled then return end
    local lastSpeedStress = 0
    while inVehicle do
        if not cache.vehicle then break end

        local vehicle = cache.vehicle
        local speed = GetEntitySpeed(vehicle)
        local convertedSpeed = speed * (Config.UseMPH and 2.236936 or 3.6)

        if GetGameTimer() - lastSpeedStress > 60 * 1000 then
            lastSpeedStress = GetGameTimer()
            if convertedSpeed >= Config.FastDrivingSpeed then
                local stressToAdd = Config.StressGain.fastDriving
                if type(stressToAdd) == "table" then
                    stressToAdd = math.random(stressToAdd.min, stressToAdd.max)
                end

                TriggerServerEvent("plrs/stress/server/addStress", stressToAdd)
            else
                local stressToAdd = Config.StressGain.driving
                if type(stressToAdd) == "table" then
                    stressToAdd = math.random(stressToAdd.min, stressToAdd.max)
                end

                TriggerServerEvent("plrs/stress/server/addStress", stressToAdd)
            end
        end

        Wait(5000)
    end
end

lib.onCache("vehicle", function(vehicle)
    inVehicle = vehicle
    if not vehicle then return end

    startVehicleThread()
end)

lib.onCache("ped", function(ped)
    startStressThread()
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= cache.resource then return end
    if not LocalPlayer.state.isLoggedIn then return end

    startStressThread()
end)

RegisterCommand("setstress", function(source, args)
    local amount = tonumber(args[1])
    if not amount then return end
    LocalPlayer.state:set("stress", amount, true)
end, false)