local Players = game:GetService("Players")

local OxygenController = {}
OxygenController.__index = OxygenController

function OxygenController.new(updateRemote, expectedEventName)
    local self = setmetatable({}, OxygenController)
    self._updateRemote = updateRemote
    self._expectedEventName = expectedEventName
    self._connection = nil
    self._gui = nil
    self._label = nil
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
    if self._gui then
        self._gui:Destroy()
        self._gui = nil
        self._label = nil
    end
end

function OxygenController:_ensureGui()
    if self._gui then
        return
    end

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "OxygenGui"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Name = "OxygenLabel"
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.new(0.5, 0, 0, 24)
    label.Size = UDim2.fromOffset(300, 40)
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 20
    label.Font = Enum.Font.GothamBold
    label.Text = "Oxygen: 100/100"
    label.Parent = gui

    self._gui = gui
    self._label = label
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

    self._label.Text = string.format("[%s] Oxygen: %d/%d", string.upper(state), math.floor(current), max)
    if failedRun then
        self._label.Text = string.format(
            "[%s] Oxygen: %d/%d - RUN FAILED (%s)",
            string.upper(state),
            math.floor(current),
            max,
            string.upper(tostring(failReason or "unknown"))
        )
    end
    
    if failedRun then
        self._label.TextColor3 = Color3.fromRGB(255, 0, 0)
    elseif state == "Base" then
        self._label.TextColor3 = Color3.fromRGB(100, 255, 100) -- Green for safe zone
    elseif current <= 20 then
        self._label.TextColor3 = Color3.fromRGB(255, 50, 50) -- Red for low oxygen
    else
        self._label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White for normal exploring
    end
end

return OxygenController
