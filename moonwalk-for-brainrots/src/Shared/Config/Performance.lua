local PerformanceConfig = {
    runtimeMonitor = {
        enabled = false, -- Resolved via Environment mode in bootstrap.
        reportIntervalSec = 5,
        targetMinFps = 30,
        lowFpsWarnThreshold = 27,
    },
}

return PerformanceConfig
