local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedRoot = ReplicatedStorage:WaitForChild("Shared")
local OxygenConfig = require(sharedRoot.Config.Oxygen)

local OxygenController = {}
OxygenController.__index = OxygenController

function OxygenController.new(updateRemote, expectedEventName)
    local self = setmetatable({}, OxygenController)
    self._updateRemote = updateRemote
    self._expectedEventName = expectedEventName
    self._connection = nil
    self._gui = nil
    self._label = nil

    self._warningTween = nil
    self._warningSound = nil
    self._isWarningActive = false

    return self
end

function OxygenController:start()
    if self._connection then
        return
    end

    self:_ensureGui()
    self._connection = self._updateRemote.OnClientEvent:Connect(function(payload)
        self:_onUpdate(payload)
    end)
end

function OxygenController:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
end

function OxygenController:destroy()
    self:stop()
    self:_setWarningActive(false)
    if self._gui then
        self._gui:Destroy()
        self._gui = nil
        self._label = nil
        self._warningSound = nil
        self._warningTween = nil
    end
end

function OxygenController:_ensureGui()
    if self._gui then
        return
    end

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Attempt to find pre-existing GUI
    local gui = playerGui:FindFirstChild("OxygenGui")

    -- Fallback to runtime creation if missing from StarterGui
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "OxygenGui"
        gui.ResetOnSpawn = false
        gui.Parent = playerGui
    end

    local label = gui:FindFirstChild("OxygenLabel")
    if not label then
        label = Instance.new("TextLabel")
        label.Name = "OxygenLabel"
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.Position = UDim2.new(0.5, 0, 0, 24)
        label.Size = UDim2.fromOffset(300, 40)
        label.BackgroundTransparency = 0.3
        label.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
        label.TextColor3 = OxygenConfig.normalTextColor
        label.TextSize = 20
        label.Font = Enum.Font.GothamBold
        label.Text = "Oxygen: 100/100"
        label.Parent = gui
    end

    local sound = gui:FindFirstChild("LowOxygenWarning")
    if not sound then
        sound = Instance.new("Sound")
        sound.Name = "LowOxygenWarning"
        sound.SoundId = OxygenConfig.warningSoundId
        sound.Volume = OxygenConfig.warningSoundVolume
        sound.Looped = true
        sound.Parent = gui
    end

    self._gui = gui
    self._label = label
    self._warningSound = sound

    -- Create the pulsing tween (color fades back and forth)
    local tweenInfo = TweenInfo.new(
        OxygenConfig.warningTweenDuration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1, -- Infinite repeat
        true -- Reverses
    )
    self._warningTween = TweenService:Create(self._label, tweenInfo, {
        TextColor3 = OxygenConfig.warningTextColor,
    })
end

function OxygenController:_setWarningActive(active)
    if self._isWarningActive == active then
        return
    end
    self._isWarningActive = active

    if active then
        if self._warningTween then
            self._warningTween:Play()
        end
        if self._warningSound then
            self._warningSound:Play()
        end
    else
        if self._warningTween then
            self._warningTween:Cancel()
        end
        if self._warningSound then
            self._warningSound:Stop()
        end
        -- The text color is reset in _onUpdate
    end
end

function OxygenController:_onUpdate(payload)
    if typeof(payload) ~= "table" then
        return
    end

    if payload.eventName ~= self._expectedEventName then
        return
    end

    local current = payload.current or 0
    local max = payload.max or 100
    local state = payload.state or "Unknown"
    local failedRun = payload.failedRun == true
    local failReason = payload.failReason
    local threshold = payload.threshold or OxygenConfig.lowOxygenWarningThreshold

    self._label.Text =
        string.format("[%s] Oxygen: %d/%d", string.upper(state), math.floor(current), max)

    local shouldWarn = not failedRun and state ~= "Base" and current <= threshold
    self:_setWarningActive(shouldWarn)

    if failedRun then
        self._label.TextColor3 = OxygenConfig.failedTextColor
    elseif state == "Base" then
        self._label.TextColor3 = OxygenConfig.safeTextColor
    elseif not shouldWarn then
        self._label.TextColor3 = OxygenConfig.normalTextColor
    end
end

return OxygenController
