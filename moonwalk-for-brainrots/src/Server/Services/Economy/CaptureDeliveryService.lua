local CollectionService = game:GetService("CollectionService")

local CaptureDeliveryService = {}
CaptureDeliveryService.__index = CaptureDeliveryService

function CaptureDeliveryService.new(config, eventNames, feedbackRemote, carryStateService, walletService, economyService)
    local self = setmetatable({}, CaptureDeliveryService)
    self._config = config
    self._eventNames = eventNames
    self._feedbackRemote = feedbackRemote
    self._carryStateService = carryStateService
    self._walletService = walletService
    self._economyService = economyService
    return self
end

function CaptureDeliveryService:requestInteract(player)
    if self._carryStateService:isCarrying(player) then
        return self:_tryDeliver(player)
    end
    return self:_tryCapture(player)
end

function CaptureDeliveryService:_tryCapture(player)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        self:_emitFeedback(player, "capture_failed", nil, "MISSING_ROOT")
        return self:_result("reject", "MISSING_ROOT")
    end

    local target = self:_findClosestTaggedTarget(root.Position, self._config.tags.captureTarget, self._config.captureRange)
    if not target then
        self:_emitFeedback(player, "capture_failed", nil, "NO_CAPTURE_TARGET")
        return self:_result("reject", "NO_CAPTURE_TARGET")
    end

    local payload = {
        brainrotId = target:GetAttribute("BrainrotId") or self._config.defaults.brainrotId,
        baseValue = target:GetAttribute("BaseValue") or self._config.defaults.baseValue,
        rarityMultiplier = target:GetAttribute("RarityMultiplier") or self._config.defaults.rarityMultiplier,
        mutationMultiplier = target:GetAttribute("MutationMultiplier") or self._config.defaults.mutationMultiplier,
        capturedAt = os.time(),
    }

    self._carryStateService:set(player, payload)
    self:_emitFeedback(player, "captured", payload)
    return self:_result("ok", "CAPTURED", payload)
end

function CaptureDeliveryService:_tryDeliver(player)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        self:_emitFeedback(player, "delivery_failed", nil, "MISSING_ROOT")
        return self:_result("reject", "MISSING_ROOT")
    end

    local deliveryPoint = self:_findClosestTaggedTarget(
        root.Position,
        self._config.tags.deliveryPoint,
        self._config.deliveryRange
    )
    if not deliveryPoint then
        self:_emitFeedback(player, "delivery_failed", nil, "NO_DELIVERY_POINT")
        return self:_result("reject", "NO_DELIVERY_POINT")
    end

    local carried = self._carryStateService:get(player)
    if not carried then
        self:_emitFeedback(player, "delivery_failed", nil, "NOT_CARRYING")
        return self:_result("reject", "NOT_CARRYING")
    end

    local payoutPreview = self._economyService and self._economyService:calculateCanonicalPayout(player, carried)
        or math.floor(carried.baseValue * carried.rarityMultiplier * carried.mutationMultiplier)
    local deliveredPayload = {
        brainrotId = carried.brainrotId,
        payoutPreview = payoutPreview,
    }

    self._walletService:addCurrency(player, payoutPreview)
    self._carryStateService:clear(player)
    self:_emitFeedback(player, "delivered", deliveredPayload)
    return self:_result("ok", "DELIVERED", deliveredPayload)
end

function CaptureDeliveryService:_findClosestTaggedTarget(originPosition, tagName, maxDistance)
    local bestInstance = nil
    local bestDistance = maxDistance

    for _, instance in ipairs(CollectionService:GetTagged(tagName)) do
        local part = self:_resolveTargetPart(instance)
        if part then
            local distance = (part.Position - originPosition).Magnitude
            if distance <= bestDistance then
                bestDistance = distance
                bestInstance = instance
            end
        end
    end

    return bestInstance
end

function CaptureDeliveryService:_resolveTargetPart(instance)
    if instance:IsA("BasePart") then
        return instance
    end

    if instance:IsA("Model") then
        return instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart")
    end

    return nil
end

function CaptureDeliveryService:_emitFeedback(player, action, data, reason)
    self._feedbackRemote:FireClient(player, {
        eventName = self._eventNames.CAPTURE_DELIVERY_FEEDBACK,
        action = action,
        data = data,
        reason = reason
    })
end

function CaptureDeliveryService:_result(kind, code, data)
    return {
        ok = kind == "ok",
        code = code,
        data = data,
    }
end

return CaptureDeliveryService
