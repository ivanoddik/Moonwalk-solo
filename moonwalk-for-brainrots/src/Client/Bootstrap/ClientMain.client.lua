local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local clientRoot = script.Parent.Parent

local InputRouter = require(clientRoot.Input.InputRouter)
local MovementController = require(clientRoot.Controllers.MovementController)
local CameraController = require(clientRoot.Controllers.CameraController)
local BaseOrientationController = require(clientRoot.Controllers.BaseOrientationController)
local MovementFeedbackController = require(clientRoot.Controllers.MovementFeedbackController)
local InteractionIntentController = require(clientRoot.Controllers.InteractionIntentController)
local PerformanceMonitorController = require(clientRoot.Controllers.PerformanceMonitorController)
local CaptureDeliveryFeedbackController =
    require(clientRoot.Controllers.CaptureDeliveryFeedbackController)
local OxygenController = require(clientRoot.Controllers.OxygenController)
local BaseMovementConfig = require(ReplicatedStorage.Shared.Config.Movement)
local BaseNavigationConfig = require(ReplicatedStorage.Shared.Config.Navigation)
local FeedbackConfig = require(ReplicatedStorage.Shared.Config.Feedback)
local EnvironmentConfig = require(ReplicatedStorage.Shared.Config.Environment)
local PerformanceConfig = require(ReplicatedStorage.Shared.Config.Performance)
local DeviceProfiles = require(ReplicatedStorage.Shared.Config.DeviceProfiles)
local ActionContracts = require(ReplicatedStorage.Shared.Constants.ActionContracts)
local EventNames = require(ReplicatedStorage.Shared.Constants.EventNames)

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local actionRemote = remotesFolder:WaitForChild("ActionIntentRemote")
local captureDeliveryFeedbackRemote = remotesFolder:WaitForChild("CaptureDeliveryFeedbackRemote")
local oxygenUpdateRemote = remotesFolder:WaitForChild("OxygenUpdateRemote")

local profileName = UserInputService.TouchEnabled and "lowEndMobile" or "default"
local MovementConfig, NavigationConfig =
    DeviceProfiles.apply(BaseMovementConfig, BaseNavigationConfig, profileName)
local environmentSettings = EnvironmentConfig.getModeSettings()

local performanceRuntimeConfig = {
    enabled = environmentSettings.performanceMonitorEnabled,
    reportIntervalSec = PerformanceConfig.runtimeMonitor.reportIntervalSec,
    targetMinFps = PerformanceConfig.runtimeMonitor.targetMinFps,
    lowFpsWarnThreshold = PerformanceConfig.runtimeMonitor.lowFpsWarnThreshold,
}

local inputRouter = InputRouter.new(MovementConfig)
local movementController = MovementController.new(MovementConfig, inputRouter)
local cameraController = CameraController.new(NavigationConfig.camera, inputRouter)
local baseOrientationController = BaseOrientationController.new(NavigationConfig.base)
local movementFeedbackController =
    MovementFeedbackController.new(FeedbackConfig.movement, movementController)
local interactionIntentController =
    InteractionIntentController.new(inputRouter, actionRemote, ActionContracts)
local captureDeliveryFeedbackController = CaptureDeliveryFeedbackController.new(
    captureDeliveryFeedbackRemote,
    EventNames.CAPTURE_DELIVERY_FEEDBACK
)
local oxygenController = OxygenController.new(oxygenUpdateRemote, EventNames.OXYGEN_UPDATE)
local performanceMonitorController =
    PerformanceMonitorController.new(performanceRuntimeConfig, movementController)

local function bindCharacter(character)
    inputRouter:setCharacter(character)
    movementController:setCharacter(character)
    cameraController:setCharacter(character)
    baseOrientationController:setCharacter(character)
    movementFeedbackController:setCharacter(character)
end

inputRouter:start()
movementController:start()
cameraController:start()
baseOrientationController:start()
movementFeedbackController:start()
interactionIntentController:start()
captureDeliveryFeedbackController:start()
oxygenController:start()
performanceMonitorController:start()

if player.Character then
    bindCharacter(player.Character)
end

player.CharacterAdded:Connect(bindCharacter)
