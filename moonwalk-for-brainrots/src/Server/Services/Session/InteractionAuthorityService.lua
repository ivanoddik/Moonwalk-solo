local InteractionAuthorityService = {}
InteractionAuthorityService.__index = InteractionAuthorityService

function InteractionAuthorityService.new(actionRemote, actionContracts, captureDeliveryService, config)
    local self = setmetatable({}, InteractionAuthorityService)
    self._actionRemote = actionRemote
    self._actionContracts = actionContracts
    self._captureDeliveryService = captureDeliveryService
    self._config = config
    self._connection = nil
    self._playerRemovingConnection = nil
    self._lastInteraction = {}
    return self
end

function InteractionAuthorityService:start()
    if self._connection then
        return
    end

    self._connection = self._actionRemote.OnServerEvent:Connect(function(player, payload)
        self:_onActionIntent(player, payload)
    end)
    
    self._playerRemovingConnection = game:GetService("Players").PlayerRemoving:Connect(function(player)
        self._lastInteraction[player.UserId] = nil
    end)
end

function InteractionAuthorityService:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
    if self._playerRemovingConnection then
        self._playerRemovingConnection:Disconnect()
        self._playerRemovingConnection = nil
    end
    self._lastInteraction = {}
end

function InteractionAuthorityService:_onActionIntent(player, payload)
    if typeof(payload) ~= "table" then
        return
    end

    local action = payload.action
    if type(action) ~= "string" then
        return
    end

    if action == self._actionContracts.INTERACT then
        local now = os.clock()
        local lastTime = self._lastInteraction[player.UserId] or 0
        local debounceTime = self._config and self._config.interactionDebounceTime or 0.5
        
        if now - lastTime < debounceTime then
            return -- Ignore spam requests
        end
        self._lastInteraction[player.UserId] = now

        if self._captureDeliveryService then
            self._captureDeliveryService:requestInteract(player)
        end
        return
    end
end

return InteractionAuthorityService
