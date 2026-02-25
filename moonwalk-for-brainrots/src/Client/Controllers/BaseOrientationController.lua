local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local BaseOrientationController = {}
BaseOrientationController.__index = BaseOrientationController

function BaseOrientationController.new(config)
    local self = setmetatable({}, BaseOrientationController)
    self._config = config
    self._player = Players.LocalPlayer
    self._character = nil
    self._root = nil
    self._gui = nil
    self._label = nil
    self._renderConnection = nil
    return self
end

function BaseOrientationController:setCharacter(character)
    self._character = character
    self._root = character and character:FindFirstChild("HumanoidRootPart") or nil
end

function BaseOrientationController:start()
    if self._renderConnection then
        return
    end

    self:_ensureGui()
    self._renderConnection = RunService.RenderStepped:Connect(function()
        self:_update()
    end)
end

function BaseOrientationController:stop()
    if self._renderConnection then
        self._renderConnection:Disconnect()
        self._renderConnection = nil
    end
end

function BaseOrientationController:destroy()
    self:stop()
    if self._gui then
        self._gui:Destroy()
        self._gui = nil
        self._label = nil
    end
end

function BaseOrientationController:_ensureGui()
    if self._gui then
        return
    end

    local playerGui = self._player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "BaseDirectionGui"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Name = self._config.hudLabelName
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.new(0.5, self._config.hudOffset.X.Offset, 0, self._config.hudOffset.Y.Offset)
    label.Size = UDim2.fromOffset(360, 32)
    label.BackgroundTransparency = 0.35
    label.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = false
    label.TextSize = 18
    label.Font = Enum.Font.GothamSemibold
    label.Text = "BASE: ---"
    label.Parent = gui

    self._gui = gui
    self._label = label
end

function BaseOrientationController:_resolveBaseAnchor()
    return Workspace:FindFirstChild(self._config.anchorName, true)
end

function BaseOrientationController:_update()
    if not self._label then
        return
    end

    local baseAnchor = self:_resolveBaseAnchor()
    if not self._root or not baseAnchor then
        self._label.Text = "BASE: NOT FOUND"
        return
    end

    local toBase = baseAnchor.Position - self._root.Position
    local distance = math.floor(toBase.Magnitude)
    local direction = self:_resolveDirection(toBase.Unit, self._root.CFrame)
    self._label.Text = string.format("BASE: %s | %dm", direction, distance)
end

function BaseOrientationController:_resolveDirection(unitToBase, rootCFrame)
    local forward = rootCFrame.LookVector
    local right = rootCFrame.RightVector
    local forwardDot = forward:Dot(unitToBase)
    local rightDot = right:Dot(unitToBase)

    if math.abs(forwardDot) >= math.abs(rightDot) then
        if forwardDot >= 0 then
            return "FRONT"
        end
        return "BACK"
    end

    if rightDot >= 0 then
        return "RIGHT"
    end
    return "LEFT"
end

return BaseOrientationController
