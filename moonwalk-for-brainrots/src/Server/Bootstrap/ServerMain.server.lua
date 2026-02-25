local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local serverRoot = ServerScriptService:WaitForChild("Server")
local sharedRoot = ReplicatedStorage:WaitForChild("Shared")

local ActionContracts = require(sharedRoot.Constants.ActionContracts)
local EventNames = require(sharedRoot.Constants.EventNames)
local CaptureDeliveryConfig = require(sharedRoot.Config.CaptureDelivery)
local OxygenConfig = require(sharedRoot.Config.Oxygen)
local InteractionAuthorityService = require(serverRoot.Services.Session.InteractionAuthorityService)
local CarryStateService = require(serverRoot.Services.Session.CarryStateService)
local CaptureDeliveryService = require(serverRoot.Services.Economy.CaptureDeliveryService)
local WalletService = require(serverRoot.Services.Economy.WalletService)
local OxygenService = require(serverRoot.Services.Oxygen.OxygenService)

local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
    remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "Remotes"
    remotesFolder.Parent = ReplicatedStorage
end

local actionRemote = remotesFolder:FindFirstChild("ActionIntentRemote")
if not actionRemote then
    actionRemote = Instance.new("RemoteEvent")
    actionRemote.Name = "ActionIntentRemote"
    actionRemote.Parent = remotesFolder
end

local feedbackRemote = remotesFolder:FindFirstChild("CaptureDeliveryFeedbackRemote")
if not feedbackRemote then
    feedbackRemote = Instance.new("RemoteEvent")
    feedbackRemote.Name = "CaptureDeliveryFeedbackRemote"
    feedbackRemote.Parent = remotesFolder
end

local oxygenUpdateRemote = remotesFolder:FindFirstChild("OxygenUpdateRemote")
if not oxygenUpdateRemote then
    oxygenUpdateRemote = Instance.new("RemoteEvent")
    oxygenUpdateRemote.Name = "OxygenUpdateRemote"
    oxygenUpdateRemote.Parent = remotesFolder
end

local carryStateService = CarryStateService.new()
carryStateService:start()
local walletService = WalletService.new()
local captureDeliveryService = CaptureDeliveryService.new(
    CaptureDeliveryConfig,
    EventNames,
    feedbackRemote,
    carryStateService,
    walletService
)

local interactionAuthorityService = InteractionAuthorityService.new(
    actionRemote,
    ActionContracts,
    captureDeliveryService,
    CaptureDeliveryConfig
)
interactionAuthorityService:start()

local baseAnchor = Workspace:FindFirstChild("BaseAnchor")
if not baseAnchor then
    baseAnchor = Instance.new("Part")
    baseAnchor.Name = "BaseAnchor"
    baseAnchor.Size = Vector3.new(4, 1, 4)
    baseAnchor.Anchored = true
    baseAnchor.CanCollide = false
    baseAnchor.Transparency = 1
    baseAnchor.Position = Vector3.new(0, 3, 0)
    baseAnchor.Parent = Workspace
end

local env = Workspace:FindFirstChild("MoonwalkEnvironment")
local baseZone = env and env:FindFirstChild("BaseZone")
local basePad = baseZone and baseZone:FindFirstChild("BasePad")
local safeZoneReference = basePad or baseZone or baseAnchor

local oxygenService = OxygenService.new(
    OxygenConfig,
    EventNames,
    oxygenUpdateRemote,
    safeZoneReference
)
oxygenService:start()
