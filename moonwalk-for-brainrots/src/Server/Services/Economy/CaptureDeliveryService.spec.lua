local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local serverRoot = ServerScriptService:WaitForChild("Server")
local sharedRoot = ReplicatedStorage:WaitForChild("Shared")

local OxygenService = require(serverRoot.Services.Oxygen.OxygenService)
local CaptureDeliveryService = require(serverRoot.Services.Economy.CaptureDeliveryService)
local CarryStateService = require(serverRoot.Services.Session.CarryStateService)
local WalletService = require(serverRoot.Services.Economy.WalletService)
local EconomyService = require(serverRoot.Services.Economy.EconomyService)

local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error(
            string.format("%s (expected %s, got %s)", message, tostring(expected), tostring(actual))
        )
    end
end

local function run()
    local carryStateService = CarryStateService.new()
    local walletService = WalletService.new()
    local economyService = EconomyService.new()

    local feedbackRemote = Instance.new("RemoteEvent")
    feedbackRemote.Name = "CaptureDeliveryFeedbackRemote"

    local captureDeliveryService = CaptureDeliveryService.new(
        {
            tags = { captureTarget = "CaptureTarget", deliveryPoint = "DeliveryPoint" },
            captureRange = 10,
            deliveryRange = 10,
        },
        { CAPTURE_DELIVERY_FEEDBACK = "CaptureDeliveryFeedback" },
        feedbackRemote,
        carryStateService,
        walletService,
        economyService
    )

    local oxygenUpdateRemote = Instance.new("RemoteEvent")
    oxygenUpdateRemote.Name = "OxygenUpdateRemote"
    local baseAnchor = Instance.new("Part")

    local oxygenService = OxygenService.new(
        {
            defaultMaxOxygen = 100,
            baseDrainRatePerSecond = 2,
            clearCarryOnDepletion = true,
            forceRespawnOnDepletion = false,
            depletedFailReason = "oxygen_depleted",
        },
        { OXYGEN_UPDATE = "Oxygen/Update" },
        oxygenUpdateRemote,
        baseAnchor,
        function(player, _failReason)
            carryStateService:clear(player)
        end
    )

    local fakePlayer = { UserId = 999, Name = "TestPlayer" }

    -- Simulate capturing an item
    carryStateService:set(
        fakePlayer,
        { baseValue = 100, rarityMultiplier = 1, mutationMultiplier = 1 }
    )
    assertEqual(carryStateService:isCarrying(fakePlayer), true, "Player should be carrying an item")

    -- Simulate Oxygen Depletion Fail State
    oxygenService:_handleOxygenDepleted(fakePlayer)

    -- Verify integration: CarryState should be cleared
    assertEqual(
        carryStateService:isCarrying(fakePlayer),
        false,
        "CarryState must be cleared on Oxygen Depletion"
    )
end

run()
return true
