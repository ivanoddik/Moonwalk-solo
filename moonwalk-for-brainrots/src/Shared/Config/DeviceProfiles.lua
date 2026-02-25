local DeviceProfiles = {}

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copied = {}
    for key, item in pairs(value) do
        copied[key] = deepCopy(item)
    end
    return copied
end

local function mergeInto(baseTable, overrides)
    for key, value in pairs(overrides) do
        if type(value) == "table" and type(baseTable[key]) == "table" then
            mergeInto(baseTable[key], value)
        else
            baseTable[key] = value
        end
    end
end

DeviceProfiles.profiles = {
    default = {
        movement = {},
        navigation = {
            camera = {},
        },
    },
    lowEndMobile = {
        movement = {
            walkSpeed = 15,
            sprintSpeed = 20,
            acceleration = 9,
            deceleration = 12,
        },
        navigation = {
            camera = {
                fieldOfViewMoving = 72,
                maxZoomDistance = 28,
            },
        },
    },
}

function DeviceProfiles.apply(baseMovementConfig, baseNavigationConfig, profileName)
    local movementConfig = deepCopy(baseMovementConfig)
    local navigationConfig = deepCopy(baseNavigationConfig)

    local profile = DeviceProfiles.profiles[profileName] or DeviceProfiles.profiles.default
    mergeInto(movementConfig, profile.movement or {})
    mergeInto(navigationConfig, profile.navigation or {})

    return movementConfig, navigationConfig
end

return DeviceProfiles
