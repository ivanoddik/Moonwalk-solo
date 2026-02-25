local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local OxygenService = {}
OxygenService.__index = OxygenService

function OxygenService.new(config, eventNames, updateRemote, baseAnchor)
    local self = setmetatable({}, OxygenService)
    self._config = config
    self._eventNames = eventNames
    self._updateRemote = updateRemote
    self._baseAnchor = baseAnchor
    self._safeZoneBoundaryBuffer = math.max(0, tonumber(config.safeZoneBoundaryBuffer) or 2)
    self._playerOxygen = {}
    self._playerState = {} -- "Base" or "Exploring"
    self._connections = {}
    self._tickConnection = nil
    
    self._lastUpdateTime = {}
    return self
end

function OxygenService:start()
    if self._tickConnection then return end

    self._connections[#self._connections + 1] = Players.PlayerAdded:Connect(function(player)
        self:_onPlayerAdded(player)
    end)
    self._connections[#self._connections + 1] = Players.PlayerRemoving:Connect(function(player)
        self:_onPlayerRemoving(player)
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        self:_onPlayerAdded(player)
    end

    self._tickConnection = RunService.Heartbeat:Connect(function(dt)
        self:_onTick(dt)
    end)
end

function OxygenService:stop()
    for _, conn in ipairs(self._connections) do
        conn:Disconnect()
    end
    self._connections = {}
    if self._tickConnection then
        self._tickConnection:Disconnect()
        self._tickConnection = nil
    end
    self._playerOxygen = {}
    self._playerState = {}
    self._lastUpdateTime = {}
end

function OxygenService:setPlayerState(player, state)
    if state ~= "Base" and state ~= "Exploring" then return end
    
    local oldState = self._playerState[player.UserId]
    self._playerState[player.UserId] = state
    
    -- If returning to base, refill oxygen (optional for now, but good UX)
    if state == "Base" and oldState == "Exploring" then
        self:_refillOxygen(player)
    end
    
    -- Send immediate state change update
    self:_sendUpdate(player)
end

function OxygenService:getOxygen(player)
    return self._playerOxygen[player.UserId] or self._config.defaultMaxOxygen
end

function OxygenService:_onPlayerAdded(player)
    self._playerState[player.UserId] = "Base"
    self:_refillOxygen(player)
end

function OxygenService:_onPlayerRemoving(player)
    self._playerOxygen[player.UserId] = nil
    self._playerState[player.UserId] = nil
    self._lastUpdateTime[player.UserId] = nil
end

function OxygenService:_refillOxygen(player)
    self._playerOxygen[player.UserId] = self._config.defaultMaxOxygen
    self:_sendUpdate(player)
end

function OxygenService:_onTick(dt)
    for _, player in ipairs(Players:GetPlayers()) do
        local userId = player.UserId
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root and self._baseAnchor then
            local newState = "Exploring"
            
            local cf, size
            if self._baseAnchor:IsA("Model") then
                cf, size = self._baseAnchor:GetBoundingBox()
            elseif self._baseAnchor:IsA("BasePart") then
                cf, size = self._baseAnchor.CFrame, self._baseAnchor.Size
            end
            
            if cf and size then
                local localPos = cf:PointToObjectSpace(root.Position)
                local halfSize = size / 2
                
                -- Expand the safe zone slightly to account for the character's physical width at the edges
                local buffer = self._safeZoneBoundaryBuffer
                
                -- Check if within the X and Z bounds (ignoring Y/height)
                if math.abs(localPos.X) <= (halfSize.X + buffer) and math.abs(localPos.Z) <= (halfSize.Z + buffer) then
                   newState = "Base"
                end
            else
                -- Fallback to simple radius if it's somehow neither
                local dist = (root.Position - self._baseAnchor.Position).Magnitude
                if dist <= self._config.safeZoneRadius then
                    newState = "Base"
                end
            end
            
            if self._playerState[userId] ~= newState then
                self:setPlayerState(player, newState)
            end
        elseif not root then
            -- If player is dead/respawning, force them to Base state so they don't drain oxygen in limbo
            if self._playerState[userId] ~= "Base" then
                self:setPlayerState(player, "Base")
            end
        end
    end

    for userId, state in pairs(self._playerState) do
        if state ~= "Exploring" then
            continue
        end

        local player = Players:GetPlayerByUserId(userId)
        if not player then continue end

        local currentOx = self._playerOxygen[userId] or self._config.defaultMaxOxygen

        if currentOx > 0 then
            local drainAmount = self._config.baseDrainRatePerSecond * dt
            self._playerOxygen[userId] = math.max(0, currentOx - drainAmount)
        else
            -- Out of oxygen: Deal damage over time
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local damageAmount = humanoid.MaxHealth * (self._config.damageRatePerSecond * dt)
                humanoid:TakeDamage(damageAmount)
            end
        end

        -- Throttle updates while exploring; Base transitions are sent immediately in setPlayerState/_refillOxygen
        local lastTime = self._lastUpdateTime[userId] or 0
        local now = os.clock()
        local throttle = self._config.networkUpdateThrottleSec or 0.1

        if now - lastTime >= throttle then
            self._lastUpdateTime[userId] = now
            self:_sendUpdate(player)
        end
    end
end

function OxygenService:_sendUpdate(player)
    if not self._updateRemote then return end
    
    local ox = self._playerOxygen[player.UserId] or self._config.defaultMaxOxygen
    local maxOx = self._config.defaultMaxOxygen
    
    self._updateRemote:FireClient(player, {
        eventName = self._eventNames.OXYGEN_UPDATE,
        current = ox,
        max = maxOx,
        state = self._playerState[player.UserId]
    })
end

return OxygenService
