local Players = game:GetService("Players")

local CarryStateService = {}
CarryStateService.__index = CarryStateService

function CarryStateService.new()
    local self = setmetatable({}, CarryStateService)
    self._statesByUserId = {}
    self._connections = {}
    return self
end

function CarryStateService:start()
    if #self._connections > 0 then
        return
    end

    local function onPlayerAdded(player)
        self._connections[#self._connections + 1] = player.CharacterAdded:Connect(function()
            -- Wipe carry state when player respawns (e.g. from oxygen death)
            self:clear(player)

            -- Also notify the client so their UI updates to remove the "Carrying: X" feedback
            -- Wait, feedback remote is handled by CaptureDeliveryService. For now, wiping state prevents delivery.
            -- A proper event could be fired, but MVP says wiping state is enough.
        end)
    end

    self._connections[#self._connections + 1] = Players.PlayerRemoving:Connect(function(player)
        self:clear(player)
    end)
    self._connections[#self._connections + 1] = Players.PlayerAdded:Connect(onPlayerAdded)

    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
end

function CarryStateService:stop()
    for _, conn in ipairs(self._connections) do
        conn:Disconnect()
    end
    self._connections = {}
    self._statesByUserId = {}
end

function CarryStateService:get(player)
    return self._statesByUserId[player.UserId]
end

function CarryStateService:isCarrying(player)
    return self:get(player) ~= nil
end

function CarryStateService:set(player, payload)
    self._statesByUserId[player.UserId] = payload
end

function CarryStateService:clear(player)
    self._statesByUserId[player.UserId] = nil
end

return CarryStateService
