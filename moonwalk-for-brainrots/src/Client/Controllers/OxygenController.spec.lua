local OxygenController = require(script.Parent:WaitForChild("OxygenController"))

local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error(
            string.format("%s (expected %s, got %s)", message, tostring(expected), tostring(actual))
        )
    end
end

local function run()
    -- Create a mock controller without connecting to real remotes or GUI
    local controller = OxygenController.new(nil, "Oxygen/Update")

    -- Mock the GUI creation so we don't depend on LocalPlayer
    controller._gui = {}
    controller._label = { Text = "", TextColor3 = Color3.new() }

    -- Inject mock methods to track warning state instead of actual Tween/Sound
    local warningActive = false
    controller._setWarningActive = function(self, active)
        warningActive = active
    end

    -- Test 1: Normal state, oxygen > threshold
    controller:_onUpdate({
        eventName = "Oxygen/Update",
        current = 50,
        max = 100,
        state = "Exploring",
        failedRun = false,
        threshold = 20,
    })
    assertEqual(warningActive, false, "Warning should be inactive when oxygen > threshold")

    -- Test 2: Low oxygen state
    controller:_onUpdate({
        eventName = "Oxygen/Update",
        current = 15,
        max = 100,
        state = "Exploring",
        failedRun = false,
        threshold = 20,
    })
    assertEqual(warningActive, true, "Warning should become active when oxygen <= threshold")

    -- Test 3: Recovery
    controller:_onUpdate({
        eventName = "Oxygen/Update",
        current = 100,
        max = 100,
        state = "Base",
        failedRun = false,
        threshold = 20,
    })
    assertEqual(
        warningActive,
        false,
        "Warning should become inactive when returning to Base and refilling"
    )

    -- Test 4: Depletion / Death
    controller:_onUpdate({
        eventName = "Oxygen/Update",
        current = 15,
        max = 100,
        state = "Exploring",
        failedRun = false,
        threshold = 20,
    })
    assertEqual(warningActive, true, "Warning active again for next test")

    controller:_onUpdate({
        eventName = "Oxygen/Update",
        current = 0,
        max = 100,
        state = "Depleted",
        failedRun = true,
        threshold = 20,
    })
    assertEqual(
        warningActive,
        false,
        "Warning should become inactive when run fails (dead/depleted)"
    )

    controller:destroy()
end

run()
return true
