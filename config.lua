Config = {}

Config.Enabled = false
Config.Notify = true
Config.ScreenEffect = true
Config.UseMPH = true
Config.FastDrivingSpeed = 100 -- in mph if UseMPH is true or kmh if not

Config.IgnoredJobs = {
    ["police"] = true,
    ["ambulance"] = true,
}

Config.IgnoredWeapons = {
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`,
    `weapon_pressure1`
}

Config.StressGain = {
    running = 1, -- set to 0 to disable, { min = x, max = y } to set a range
    shooting = { min = 1, max = 3 },
    driving = 1.5,
    fastDriving = 3,
    crash = { min = 8, max = 15 }
}

Config.ScreenEffect = {
    blur = {
        { min = 40, max = 50, timeout = 1500 },
        { min = 50, max = 60, timeout = 2000 },
        { min = 60, max = 70, timeout = 2500 },
        { min = 70, max = 80, timeout = 3000 },
        { min = 80, max = 90, timeout = 3250 },
        { min = 90, max = 100, timeout = 3600 },
    },
    interval = {
        { min = 40, max = 50, timeout = math.random(50000, 60000) },
        { min = 50, max = 60, timeout = math.random(40000, 50000) },
        { min = 60, max = 70, timeout = math.random(30000, 40000) },
        { min = 70, max = 80, timeout = math.random(20000, 30000) },
        { min = 80, max = 90, timeout = math.random(15000, 20000) },
        { min = 90, max = 100, timeout = math.random(10000, 15000) },
    },
    shakeStart = 85,
}
