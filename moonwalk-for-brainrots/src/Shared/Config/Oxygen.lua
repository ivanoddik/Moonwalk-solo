local OxygenConfig = {
    defaultMaxOxygen = 100,
    baseDrainRatePerSecond = 2,
    safeZoneRadius = 15,
    safeZoneBoundaryBuffer = 2,
    networkUpdateThrottleSec = 0.1,
    damageRatePerSecond = 0.1, -- 10% of max health per second
    clearCarryOnDepletion = true,
    forceRespawnOnDepletion = true,
    depletedFailReason = "oxygen_depleted",
    respawnDelaySeconds = 1.5,
    lowOxygenWarningThreshold = 20,
    
    -- Visual and Audio Warning Config
    warningSoundId = "rbxassetid://876939830",
    warningSoundVolume = 0.5,
    warningTweenDuration = 0.5,
    normalTextColor = Color3.fromRGB(255, 255, 255),
    warningTextColor = Color3.fromRGB(255, 50, 50),
    safeTextColor = Color3.fromRGB(100, 255, 100),
    failedTextColor = Color3.fromRGB(255, 0, 0),
}

return OxygenConfig
