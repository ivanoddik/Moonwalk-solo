local EnvironmentConfig = {
    -- Change this when preparing specific builds.
    runtimeMode = "dev", -- dev | staging | prod

    modes = {
        dev = {
            performanceMonitorEnabled = true,
        },
        staging = {
            performanceMonitorEnabled = true,
        },
        prod = {
            performanceMonitorEnabled = false,
        },
    },
}

function EnvironmentConfig.getModeSettings()
    return EnvironmentConfig.modes[EnvironmentConfig.runtimeMode] or EnvironmentConfig.modes.prod
end

return EnvironmentConfig
