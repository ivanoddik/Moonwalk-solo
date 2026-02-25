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
}

return OxygenConfig
