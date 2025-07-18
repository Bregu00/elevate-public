local randomLocation = Config.Blackmarket.locations[math.random(1, #Config.Blackmarket.locations)]

lib.callback.register('jungurum-smallresources:server:getBlackmarket', function(source)
    return randomLocation
end)

CreateThread(function()
    exports['ox_inventory']:RegisterShop('BlackMarket', {
        name = 'Black Market',
        inventory = Config.Blackmarket.items
    })
end)