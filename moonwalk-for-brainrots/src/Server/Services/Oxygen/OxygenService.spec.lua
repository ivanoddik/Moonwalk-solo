local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s (expected %s, got %s)", message, tostring(expected), tostring(actual)))
    end
end

local function computeNextOxygen(current, drainRatePerSecond, dt)
    if current <= 0 then
        return 0
    end

    return math.max(0, current - (drainRatePerSecond * dt))
end

local function run()
    assertEqual(computeNextOxygen(100, 2, 1), 98, "should drain oxygen per second")
    assertEqual(computeNextOxygen(1, 2, 1), 0, "should clamp oxygen at zero")
    assertEqual(computeNextOxygen(0, 2, 1), 0, "should stay at zero once depleted")
end

run()
return true
