local RunService = game:GetService("RunService")

local InteractionIntentController = {}
InteractionIntentController.__index = InteractionIntentController

function InteractionIntentController.new(inputRouter, actionRemote, actionContracts)
    local self = setmetatable({}, InteractionIntentController)
    self._inputRouter = inputRouter
    self._actionRemote = actionRemote
    self._actionContracts = actionContracts
    self._heartbeatConnection = nil
    self._lastSentAt = 0
    self._sendCooldownSec = 0.08
    return self
end

function InteractionIntentController:start()
    if self._heartbeatConnection then
        return
    end

    self._heartbeatConnection = RunService.Heartbeat:Connect(function()
        self:_onHeartbeat()
    end)
end

function InteractionIntentController:stop()
    if self._heartbeatConnection then
        self._heartbeatConnection:Disconnect()
        self._heartbeatConnection = nil
    end
end

function InteractionIntentController:destroy()
    self:stop()
end

function InteractionIntentController:_onHeartbeat()
    if not self._inputRouter:consumeInteractRequested() then
        return
    end

    local now = os.clock()
    if now - self._lastSentAt < self._sendCooldownSec then
        return
    end
    self._lastSentAt = now

    -- Send intent only. Server resolves target and authority-sensitive outcomes.
    self._actionRemote:FireServer({
        action = self._actionContracts.INTERACT,
    })
end

return InteractionIntentController
