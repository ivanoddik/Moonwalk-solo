local Players = game:GetService("Players")

local CaptureDeliveryFeedbackController = {}
CaptureDeliveryFeedbackController.__index = CaptureDeliveryFeedbackController

function CaptureDeliveryFeedbackController.new(feedbackRemote, expectedEventName)
    local self = setmetatable({}, CaptureDeliveryFeedbackController)
    self._feedbackRemote = feedbackRemote
    self._expectedEventName = expectedEventName
    self._connection = nil
    self._gui = nil
    self._label = nil
    return self
end

function CaptureDeliveryFeedbackController:start()
    if self._connection then
        return
    end

    self:_ensureGui()
    self._connection = self._feedbackRemote.OnClientEvent:Connect(function(payload)
        self:_onFeedback(payload)
    end)

    self._charConnection = Players.LocalPlayer.CharacterAdded:Connect(function()
        if self._label then
            self._label.Text = "Capture/Delivery feedback ready"
            self._label.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
        end
    end)
end

function CaptureDeliveryFeedbackController:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
    if self._charConnection then
        self._charConnection:Disconnect()
        self._charConnection = nil
    end
end

function CaptureDeliveryFeedbackController:destroy()
    self:stop()
    if self._gui then
        self._gui:Destroy()
        self._gui = nil
        self._label = nil
    end
end

function CaptureDeliveryFeedbackController:_ensureGui()
    if self._gui then
        return
    end

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "CaptureDeliveryFeedbackGui"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Name = "CaptureDeliveryFeedbackLabel"
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Position = UDim2.new(0.5, 0, 1, -24)
    label.Size = UDim2.fromOffset(460, 30)
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamMedium
    label.Text = "Capture/Delivery feedback ready"
    label.Parent = gui

    self._gui = gui
    self._label = label
end

function CaptureDeliveryFeedbackController:_onFeedback(payload)
    if typeof(payload) ~= "table" then
        return
    end

    if payload.eventName ~= self._expectedEventName then
        return
    end

    local action = payload.action
    local data = payload.data or {}
    if action == "captured" then
        self._label.Text = string.format("Carrying: %s", tostring(data.brainrotId))
        self._label.BackgroundColor3 = Color3.fromRGB(100, 80, 12)
        return
    end

    if action == "delivered" then
        self._label.Text = string.format(
            "Delivered: %s | Payout preview: %d",
            tostring(data.brainrotId),
            tonumber(data.payoutPreview) or 0
        )
        self._label.BackgroundColor3 = Color3.fromRGB(12, 100, 28)
        self:_resetColor()
        return
    end

    if action == "capture_failed" then
        self._label.Text = string.format("Capture Failed: %s", tostring(payload.reason))
        self._label.BackgroundColor3 = Color3.fromRGB(150, 18, 28)
        self:_resetColor()
        return
    end

    if action == "delivery_failed" then
        self._label.Text = string.format("Delivery Failed: %s", tostring(payload.reason))
        self._label.BackgroundColor3 = Color3.fromRGB(150, 18, 28)
        self:_resetColor()
        return
    end

    self._label.Text = "Interaction received"
end

function CaptureDeliveryFeedbackController:_resetColor()
    if self._colorResetThread then
        task.cancel(self._colorResetThread)
    end
    self._colorResetThread = task.delay(1.5, function()
        if self._label then
            self._label.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
        end
    end)
end

return CaptureDeliveryFeedbackController
