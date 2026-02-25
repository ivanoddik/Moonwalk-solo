local RunService = game:GetService("RunService")

local MovementController = {}
MovementController.__index = MovementController

function MovementController.new(config, inputRouter)
    local self = setmetatable({}, MovementController)
    self._config = config
    self._inputRouter = inputRouter
    self._humanoid = nil
    self._state = "Idle"
    self._currentSpeed = config.walkSpeed
    self._heartbeatConnection = nil
    self._stateChangedEvent = Instance.new("BindableEvent")
    return self
end

function MovementController:setCharacter(character)
    self._humanoid = character and character:FindFirstChildOfClass("Humanoid") or nil
    if self._humanoid then
        self._humanoid.WalkSpeed = self._currentSpeed
    end
end

function MovementController:getState()
    return self._state
end

function MovementController:getStateChangedSignal()
    return self._stateChangedEvent.Event
end

function MovementController:start()
    if self._heartbeatConnection then
        return
    end

    self._heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        self:_onHeartbeat(deltaTime)
    end)
end

function MovementController:stop()
    if self._heartbeatConnection then
        self._heartbeatConnection:Disconnect()
        self._heartbeatConnection = nil
    end
end

function MovementController:destroy()
    self:stop()
    self._stateChangedEvent:Destroy()
end

function MovementController:_onHeartbeat(deltaTime)
    if not self._humanoid then
        self:_setState("Idle")
        return
    end

    local moveVector = self._inputRouter:getMoveVector()
    local magnitude = moveVector.Magnitude
    local moving = magnitude >= self._config.minMovingMagnitude

    local targetSpeed = self._config.walkSpeed
    if moving and self._inputRouter:isSprintRequested() then
        targetSpeed = self._config.sprintSpeed
    end

    local accel = self._config.acceleration
    local decel = self._config.deceleration
    local rate = targetSpeed >= self._currentSpeed and accel or decel
    local alpha = math.clamp(rate * deltaTime, 0, 1)
    self._currentSpeed = self._currentSpeed + (targetSpeed - self._currentSpeed) * alpha

    self._humanoid.WalkSpeed = self._currentSpeed

    if moving then
        self:_setState("Moving")
    elseif self._state == "Moving" then
        self:_setState("Stopped")
    else
        self:_setState("Idle")
    end
end

function MovementController:_setState(newState)
    if self._state == newState then
        return
    end
    self._state = newState
    self._stateChangedEvent:Fire(newState)
end

return MovementController
