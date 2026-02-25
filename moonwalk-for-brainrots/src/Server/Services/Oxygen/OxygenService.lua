local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local DEFAULT_BASE_DRAIN_RATE_PER_SECOND = 2
local DEFAULT_DEPLETED_REASON = "oxygen_depleted"

local OxygenService = {}
OxygenService.__index = OxygenService

function OxygenService.new(config, eventNames, updateRemote, baseAnchor, onDepleted)
    local self = setmetatable({}, OxygenService)
    self._config = config
    self._eventNames = eventNames
    self._updateRemote = updateRemote
    self._baseAnchor = baseAnchor
    self._onDepleted = onDepleted
    local configuredDrainRate = tonumber(config.baseDrainRatePerSecond)
    if configuredDrainRate == nil or configuredDrainRate <= 0 then
        error("OxygenService requires baseDrainRatePerSecond > 0 in Oxygen config")
    end
    self._baseDrainRatePerSecond = configuredDrainRate
    self._safeZoneBoundaryBuffer = math.max(0, tonumber(config.safeZoneBoundaryBuffer) or 2)
    self._playerOxygen = {}
    self._playerState = {} -- "Base" or "Exploring"
    self._playerFailedRun = {}
    self._playerFailReason = {}
    self._connections = {}
    self._diedConnections = {}
    self._tickConnection = nil
    
    self._lastUpdateTime = {}
    return self
end

function OxygenService.shouldTriggerFailState(state, previousOxygen, nextOxygen, alreadyFailed)
    return state == "Exploring" and not alreadyFailed and previousOxygen > 0 and nextOxygen <= 0
end

function OxygenService:_getFlatExploringDrainRatePerSecond()
    -- Story 3.2 guardrail: exploring drain must remain flat and configurable, not depth-scaled.
    return self._baseDrainRatePerSecond or DEFAULT_BASE_DRAIN_RATE_PER_SECOND
end

function OxygenService:_getDepletedFailReason()
    return self._config.depletedFailReason or DEFAULT_DEPLETED_REASON
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
    self._playerFailedRun = {}
    self._playerFailReason = {}
    self._diedConnections = {}
    self._lastUpdateTime = {}
end

function OxygenService:setPlayerState(player, state)
    if state ~= "Base" and state ~= "Exploring" and state ~= "Depleted" then
        return
    end
    
    local oldState = self._playerState[player.UserId]
    self._playerState[player.UserId] = state
    
    if state == "Base" then
        self._playerFailedRun[player.UserId] = false
        self._playerFailReason[player.UserId] = nil
    end

    -- If returning to base from an active/depleted run, refill oxygen.
    if state == "Base" and (oldState == "Exploring" or oldState == "Depleted") then
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
    self._playerFailedRun[player.UserId] = false
    self._playerFailReason[player.UserId] = nil
    self:_refillOxygen(player)

    local function onCharacterAdded(character)
        -- Clean up previous connection if it exists
        if self._diedConnections[player.UserId] then
            self._diedConnections[player.UserId]:Disconnect()
            self._diedConnections[player.UserId] = nil
        end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            self._diedConnections[player.UserId] = humanoid.Died:Connect(function()
                if self._config.forceRespawnOnDepletion then
                    local delayTime = tonumber(self._config.respawnDelaySeconds) or 1.5
                    task.delay(delayTime, function()
                        if player and player.Parent then
                            -- Instantly transition state so UI resets before character finishes loading
                            self:setPlayerState(player, "Base")
                            player:LoadCharacter()
                        end
                    end)
                end
            end)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    self._connections[#self._connections + 1] = player.CharacterAdded:Connect(onCharacterAdded)
end

function OxygenService:_onPlayerRemoving(player)
    self._playerOxygen[player.UserId] = nil
    self._playerState[player.UserId] = nil
    self._playerFailedRun[player.UserId] = nil
    self._playerFailedRun[player.UserId] = nil
    self._playerFailReason[player.UserId] = nil
    if self._diedConnections[player.UserId] then
        self._diedConnections[player.UserId]:Disconnect()
        self._diedConnections[player.UserId] = nil
    end
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
            
            -- Cache the bounding box calculation per tick instead of per player
            if not self._cachedAnchorPos and not self._cachedAnchorSize then
                if self._baseAnchor:IsA("Model") then
                    self._cachedAnchorPos, self._cachedAnchorSize = self._baseAnchor:GetBoundingBox()
                elseif self._baseAnchor:IsA("BasePart") then
                    self._cachedAnchorPos, self._cachedAnchorSize = self._baseAnchor.CFrame, self._baseAnchor.Size
                end
            end
            
            local cf, size = self._cachedAnchorPos, self._cachedAnchorSize
            if cf and size then
                local localPos = cf:PointToObjectSpace(root.Position)
                local halfSize = size / 2
                
                -- Expand the safe zone slightly to account for the character's physical width at the edges
                local buffer = self._safeZoneBoundaryBuffer
                
                -- Check if within the X and Z bounds (ignoring Y/height)
                if math.abs(localPos.X) <= (halfSize.X + buffer) and math.abs(localPos.Z) <= (halfSize.Z + buffer) then
                   newState = "Base"
                end
            elseif self._baseAnchor:IsA("BasePart") or self._baseAnchor:IsA("Model") then
                -- Fallback to simple radius if CFrame isn't readily available
                local pos = self._baseAnchor:IsA("Model") and self._baseAnchor:GetPivot().Position or self._baseAnchor.Position
                local dist = (root.Position - pos).Magnitude
                if dist <= self._config.safeZoneRadius then
                    newState = "Base"
                end
            end
            
            if self._playerState[userId] ~= newState then
                -- Do not overwrite Depleted with Exploring. (Once depleted, you must return to Base to clear it)
                if self._playerState[userId] == "Depleted" and newState == "Exploring" then
                    -- Keep Depleted state
                else
                    self:setPlayerState(player, newState)
                end
            end
        elseif not root then
            -- If player is dead/respawning, force them to Base state so they don't drain oxygen in limbo
            if self._playerState[userId] ~= "Base" then
                self:setPlayerState(player, "Base")
            end
        end
    end

    -- Clear anchor cache for next tick to handle any potential anchor movement
    self._cachedAnchorPos = nil
    self._cachedAnchorSize = nil

    for userId, state in pairs(self._playerState) do
        if state ~= "Exploring" and state ~= "Depleted" then
            continue
        end

        local player = Players:GetPlayerByUserId(userId)
        if not player then continue end

        local currentOx = self._playerOxygen[userId] or self._config.defaultMaxOxygen

        if currentOx > 0 and state == "Exploring" then
            local nextOx = OxygenService.computeNextOxygen(
                currentOx,
                self:_getFlatExploringDrainRatePerSecond(),
                dt
            )
            local alreadyFailed = self._playerFailedRun[userId] == true
            local shouldFail = OxygenService.shouldTriggerFailState(
                state,
                currentOx,
                nextOx,
                alreadyFailed
            )
            self._playerOxygen[userId] = nextOx

            if shouldFail then
                self:_handleOxygenDepleted(player)
            end
        elseif currentOx <= 0 and state == "Depleted" then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local dmg = humanoid.MaxHealth * (self._config.damageRatePerSecond or 0.1) * dt
                humanoid.Health = math.max(0, humanoid.Health - dmg)
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

function OxygenService:_handleOxygenDepleted(player)
    local userId = player.UserId
    if self._playerFailedRun[userId] then
        return
    end

    local failReason = self:_getDepletedFailReason()
    self._playerFailedRun[userId] = true
    self._playerFailReason[userId] = failReason
    self._playerState[userId] = "Depleted"

    if self._config.clearCarryOnDepletion and self._onDepleted then
        self._onDepleted(player, failReason)
    end

    self:_sendUpdate(player)
end

function OxygenService.computeNextOxygen(current, configuredFlatDrainRatePerSecond, dt)
    if current <= 0 then
        return 0
    end

    return math.max(0, current - (configuredFlatDrainRatePerSecond * dt))
end

function OxygenService.buildUpdatePayload(eventName, current, max, state, failedRun, failReason)
    return {
        eventName = eventName,
        current = current,
        max = max,
        state = state,
        failedRun = failedRun == true,
        failReason = failReason,
    }
end

function OxygenService:_sendUpdate(player)
    if not self._updateRemote then return end
    
    local ox = self._playerOxygen[player.UserId] or self._config.defaultMaxOxygen
    local maxOx = self._config.defaultMaxOxygen
    
    self._updateRemote:FireClient(
        player,
        OxygenService.buildUpdatePayload(
            self._eventNames.OXYGEN_UPDATE,
            ox,
            maxOx,
            self._playerState[player.UserId],
            self._playerFailedRun[player.UserId],
            self._playerFailReason[player.UserId]
        )
    )
end

return OxygenService
