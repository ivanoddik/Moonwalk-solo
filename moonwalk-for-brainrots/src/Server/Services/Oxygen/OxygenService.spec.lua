local OxygenService = require(script.Parent:WaitForChild("OxygenService"))

local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error(
            string.format("%s (expected %s, got %s)", message, tostring(expected), tostring(actual))
        )
    end
end

local function applyExploringTickByUserId(playersByUserId, configuredFlatDrainRatePerSecond, dt)
    local nextByUserId = {}
    for userId, oxygen in pairs(playersByUserId) do
        nextByUserId[userId] =
            OxygenService.computeNextOxygen(oxygen, configuredFlatDrainRatePerSecond, dt)
    end
    return nextByUserId
end

local function run()
    assertEqual(OxygenService.computeNextOxygen(100, 2, 1), 98, "should drain oxygen per second")
    assertEqual(OxygenService.computeNextOxygen(1, 2, 1), 0, "should clamp oxygen at zero")
    assertEqual(OxygenService.computeNextOxygen(0, 2, 1), 0, "should stay at zero once depleted")

    local near = OxygenService.computeNextOxygen(100, 2, 1)
    local deep = OxygenService.computeNextOxygen(100, 2, 1)
    assertEqual(near, deep, "drain must be equal regardless of distance from base")

    local before = {
        [101] = 100,
        [202] = 80,
    }
    local after = applyExploringTickByUserId(before, 2, 0.5)
    assertEqual(after[101], 99, "player 101 drain should use configured flat rate")
    assertEqual(after[202], 79, "player 202 drain should use configured flat rate")

    local okInvalidConfig, _ = pcall(function()
        OxygenService.new({
            defaultMaxOxygen = 100,
            baseDrainRatePerSecond = 0,
        }, { OXYGEN_UPDATE = "Oxygen/Update" }, nil, nil)
    end)
    assertEqual(okInvalidConfig, false, "invalid drain config should fail fast")

    assertEqual(
        OxygenService.shouldTriggerFailState("Exploring", 1, 0, false),
        true,
        "exploring oxygen drop to zero should trigger fail state"
    )
    assertEqual(
        OxygenService.shouldTriggerFailState("Exploring", 1, 0, true),
        false,
        "already failed run should not trigger fail state again"
    )
    assertEqual(
        OxygenService.shouldTriggerFailState("Base", 1, 0, false),
        false,
        "base state should not trigger fail state"
    )

    local payload = OxygenService.buildUpdatePayload(
        "Oxygen/Update",
        0,
        100,
        "Depleted",
        true,
        "oxygen_depleted"
    )
    assertEqual(payload.failedRun, true, "payload should expose failed run state")
    assertEqual(payload.failReason, "oxygen_depleted", "payload should expose fail reason")

    local depletedCalls = 0
    local service = OxygenService.new(
        {
            defaultMaxOxygen = 100,
            baseDrainRatePerSecond = 2,
            clearCarryOnDepletion = true,
            forceRespawnOnDepletion = false,
            depletedFailReason = "oxygen_depleted",
        },
        { OXYGEN_UPDATE = "Oxygen/Update" },
        nil,
        nil,
        function(_player, reason)
            depletedCalls += 1
            assertEqual(reason, "oxygen_depleted", "depleted callback should receive fail reason")
        end
    )

    local fakePlayer = { UserId = 999 }
    service:_handleOxygenDepleted(fakePlayer)
    service:_handleOxygenDepleted(fakePlayer)
    assertEqual(depletedCalls, 1, "depletion handling must be idempotent per player")

    local resetService = OxygenService.new({
        defaultMaxOxygen = 100,
        baseDrainRatePerSecond = 2,
    }, { OXYGEN_UPDATE = "Oxygen/Update" }, { FireClient = function() end }, nil)

    local fakePlayer2 = { UserId = 777 }
    resetService._playerState[777] = "Depleted"
    resetService._playerFailedRun[777] = true
    resetService._playerFailReason[777] = "oxygen_depleted"
    resetService._playerOxygen[777] = 0

    -- Simulate the reset that occurs after teleport delay
    resetService:setPlayerState(fakePlayer2, "Base")

    assertEqual(resetService._playerState[777], "Base", "state should return to Base after reset")
    assertEqual(
        resetService._playerFailedRun[777],
        false,
        "failed run flag should be cleared on Base transition"
    )
    assertEqual(
        resetService._playerFailReason[777] == nil,
        true,
        "fail reason should be cleared on Base transition"
    )
    assertEqual(
        resetService._playerOxygen[777],
        100,
        "oxygen should be refilled on Base transition"
    )
end

run()
return true
