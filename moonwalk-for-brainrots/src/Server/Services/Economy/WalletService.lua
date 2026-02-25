local WalletService = {}
WalletService.__index = WalletService

function WalletService.new()
    local self = setmetatable({}, WalletService)
    self._wallets = {}
    return self
end

function WalletService:addCurrency(player, amount)
    local userId = player.UserId
    self._wallets[userId] = (self._wallets[userId] or 0) + amount
    -- Fire a remote here later to update UI, but keep it simple for now
    print(
        string.format(
            "[WalletService] Player %s earned %d. Total: %d",
            player.Name,
            amount,
            self._wallets[userId]
        )
    )
    return self._wallets[userId]
end

function WalletService:getCurrency(player)
    return self._wallets[player.UserId] or 0
end

return WalletService
