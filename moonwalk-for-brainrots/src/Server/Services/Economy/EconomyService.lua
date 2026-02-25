local EconomyService = {}
EconomyService.__index = EconomyService

function EconomyService.new(config)
    local self = setmetatable({}, EconomyService)
    self._config = config
    return self
end

function EconomyService:calculateCanonicalPayout(player, payload)
    -- Base: baseValue
    -- Rarity/Mutation: rarityMultiplier, mutationMultiplier
    -- Rebirth: (not implemented yet, but reserved)
    -- Monetization: (not implemented yet, but reserved)

    local base = payload.baseValue or 0
    local rarity = payload.rarityMultiplier or 1
    local mutation = payload.mutationMultiplier or 1

    local payout = base * rarity * mutation

    -- Future hooks: payout = self:applyRebirthMultipliers(player, payout)
    -- Future hooks: payout = self:applyMonetizationMultipliers(player, payout)

    return math.floor(payout)
end

return EconomyService
