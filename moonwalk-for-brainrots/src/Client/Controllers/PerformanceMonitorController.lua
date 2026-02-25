local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local PerformanceMonitorController = {}
PerformanceMonitorController.__index = PerformanceMonitorController

function PerformanceMonitorController.new(config, movementController)
    local self = setmetatable({}, PerformanceMonitorController)
    self._config = config
    self._movementController = movementController
    self._connection = nil
    self._elapsed = 0
    self._frames = 0
    self._movingFrames = 0
    return self
end

function PerformanceMonitorController:start()
    if not self._config.enabled or self._connection then
        return
    end

    self._connection = RunService.RenderStepped:Connect(function(deltaTime)
        self:_onFrame(deltaTime)
    end)
end

function PerformanceMonitorController:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
end

function PerformanceMonitorController:destroy()
    self:stop()
end

function PerformanceMonitorController:_onFrame(deltaTime)
    self._elapsed += deltaTime
    self._frames += 1

    local state = self._movementController:getState()
    if state == "Moving" then
        self._movingFrames += 1
    end

    if self._elapsed < self._config.reportIntervalSec then
        return
    end

    local avgDelta = self._elapsed / math.max(self._frames, 1)
    local avgFps = math.floor(1 / math.max(avgDelta, 1 / 240))
    local movingPct = math.floor((self._movingFrames / math.max(self._frames, 1)) * 100)
    local profile = UserInputService.TouchEnabled and "lowEndMobile" or "default"

    if avgFps <= self._config.lowFpsWarnThreshold then
        warn(
            string.format(
                "[PerfMonitor][WARN] avgFps=%d target=%d movingPct=%d profile=%s",
                avgFps,
                self._config.targetMinFps,
                movingPct,
                profile
            )
        )
    else
        print(
            string.format(
                "[PerfMonitor] avgFps=%d movingPct=%d profile=%s",
                avgFps,
                movingPct,
                profile
            )
        )
    end

    self._elapsed = 0
    self._frames = 0
    self._movingFrames = 0
end

return PerformanceMonitorController
