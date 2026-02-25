local SoundService = game:GetService("SoundService")

local MovementFeedbackController = {}
MovementFeedbackController.__index = MovementFeedbackController

function MovementFeedbackController.new(config, movementController)
    local self = setmetatable({}, MovementFeedbackController)
    self._config = config
    self._movementController = movementController
    self._character = nil
    self._stateConnection = nil
    self._isMoving = false
    self._cachedSounds = {}
    return self
end

function MovementFeedbackController:setCharacter(character)
    self._character = character
end

function MovementFeedbackController:start()
    if self._stateConnection then
        return
    end

    self._stateConnection = self._movementController:getStateChangedSignal():Connect(function(newState)
        self:_applyState(newState)
    end)

    self:_applyState(self._movementController:getState())
end

function MovementFeedbackController:stop()
    if self._stateConnection then
        self._stateConnection:Disconnect()
        self._stateConnection = nil
    end
end

function MovementFeedbackController:destroy()
    self:stop()
end

function MovementFeedbackController:_resolveSound(soundName)
    if not self._config.enableSfx or not soundName or soundName == "" then
        return nil
    end

    if self._cachedSounds[soundName] then
        return self._cachedSounds[soundName]
    end

    local soundsFolder = SoundService:FindFirstChild(self._config.soundsFolderName)
    local sound = soundsFolder and soundsFolder:FindFirstChild(soundName)
    if sound and sound:IsA("Sound") then
        self._cachedSounds[soundName] = sound
        return sound
    end

    return nil
end

function MovementFeedbackController:_setTrailEnabled(enabled)
    if not self._config.enableTrail or not self._character then
        return
    end

    for _, descendant in self._character:GetDescendants() do
        if descendant.Name == self._config.trailName and descendant:IsA("Trail") then
            descendant.Enabled = enabled
        end
    end
end

function MovementFeedbackController:_playOneShot(soundName)
    local sound = self:_resolveSound(soundName)
    if sound then
        sound:Play()
    end
end

function MovementFeedbackController:_setLoopEnabled(enabled)
    local loopSound = self:_resolveSound(self._config.moveLoopSfxName)
    if not loopSound then
        return
    end

    if enabled then
        if not loopSound.IsPlaying then
            loopSound:Play()
        end
    elseif loopSound.IsPlaying then
        loopSound:Stop()
    end
end

function MovementFeedbackController:_applyState(state)
    local moving = state == "Moving"
    if moving == self._isMoving then
        return
    end

    self._isMoving = moving

    if moving then
        self:_playOneShot(self._config.moveStartSfxName)
        self:_setLoopEnabled(true)
        self:_setTrailEnabled(true)
    else
        self:_setLoopEnabled(false)
        self:_setTrailEnabled(false)
        self:_playOneShot(self._config.moveStopSfxName)
    end
end

return MovementFeedbackController
