local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CameraController = {}
CameraController.__index = CameraController

function CameraController.new(config, inputRouter)
    local self = setmetatable({}, CameraController)
    self._config = config
    self._inputRouter = inputRouter
    self._player = Players.LocalPlayer
    self._camera = Workspace.CurrentCamera
    self._humanoid = nil
    self._renderConnection = nil
    return self
end

function CameraController:setCharacter(character)
    self._humanoid = character and character:FindFirstChildOfClass("Humanoid") or nil

    if self._camera and self._humanoid then
        self._camera.CameraType = Enum.CameraType.Custom
        self._camera.CameraSubject = self._humanoid
    end
end

function CameraController:start()
    if self._renderConnection then
        return
    end

    self._player.CameraMinZoomDistance = self._config.minZoomDistance
    self._player.CameraMaxZoomDistance = self._config.maxZoomDistance

    self._renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        self:_onRenderStepped(deltaTime)
    end)
end

function CameraController:stop()
    if self._renderConnection then
        self._renderConnection:Disconnect()
        self._renderConnection = nil
    end
end

function CameraController:destroy()
    self:stop()
end

function CameraController:_onRenderStepped(deltaTime)
    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    local moving = self._inputRouter:getMoveVector().Magnitude > 0.05
    local targetFov = moving and self._config.fieldOfViewMoving or self._config.fieldOfViewIdle
    local alpha = math.clamp(self._config.fovLerpSpeed * deltaTime, 0, 1)
    camera.FieldOfView = camera.FieldOfView + (targetFov - camera.FieldOfView) * alpha
end

return CameraController
