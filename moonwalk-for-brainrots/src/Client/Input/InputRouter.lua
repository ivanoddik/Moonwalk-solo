local ContextActionService = game:GetService("ContextActionService")

local ACTION_INTERACT = "Input/Interact"
local ACTION_SPRINT = "Input/Sprint"

local InputRouter = {}
InputRouter.__index = InputRouter

function InputRouter.new(config)
    local self = setmetatable({}, InputRouter)
    self._config = config
    self._humanoid = nil
    self._sprintRequested = false
    self._interactRequested = false
    self._isStarted = false
    return self
end

function InputRouter:setCharacter(character)
    self._humanoid = character and character:FindFirstChildOfClass("Humanoid") or nil
end

function InputRouter:getMoveVector()
    if not self._humanoid then
        return Vector3.zero
    end

    -- MoveDirection is already device-agnostic through Roblox default controls.
    return self._humanoid.MoveDirection
end

function InputRouter:isSprintRequested()
    return self._sprintRequested
end

function InputRouter:consumeInteractRequested()
    local wasRequested = self._interactRequested
    self._interactRequested = false
    return wasRequested
end

function InputRouter:start()
    if self._isStarted then
        return
    end
    self._isStarted = true

    local priority = self._config.inputActionPriority or 2000

    ContextActionService:BindActionAtPriority(ACTION_INTERACT, function(_, inputState)
        if inputState == Enum.UserInputState.Begin then
            self._interactRequested = true
        end
        return Enum.ContextActionResult.Pass
    end, true, priority, Enum.KeyCode.E, Enum.KeyCode.ButtonX)

    ContextActionService:BindActionAtPriority(ACTION_SPRINT, function(_, inputState)
        self._sprintRequested = inputState == Enum.UserInputState.Begin
        if inputState == Enum.UserInputState.End then
            self._sprintRequested = false
        end
        return Enum.ContextActionResult.Pass
    end, false, priority, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonL3)
end

function InputRouter:destroy()
    ContextActionService:UnbindAction(ACTION_INTERACT)
    ContextActionService:UnbindAction(ACTION_SPRINT)
    self._isStarted = false
end

return InputRouter
