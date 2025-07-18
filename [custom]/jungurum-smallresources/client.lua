exports("getHolsterConfig", function()
    return Config.Holsters
end)

local function GetPlayerMaxWeight()
    local playerPed = PlayerPedId()
	local playerModel = GetEntityModel(playerPed)
	local bagSize = 0
	local prop = { draw = GetPedDrawableVariation(playerPed, Config.Holsters.ValidPedBags[playerModel].variation), texture = GetPedTextureVariation(playerPed, Config.Holsters.ValidPedBags[playerModel].variation) }
    if not Config.Holsters.ValidPedBags[playerModel] then return 0 end
    if not Config.Holsters.ValidPedBags[playerModel].bags[prop.draw] then return 0 end
    local bag = Config.Holsters.ValidPedBags[playerModel].bags[prop.draw]
    local addToBagSize = bag or 0
    if prop.texture == 255 or prop.texture == -1 then addToBagSize = 0 end
    bagSize = bagSize + addToBagSize

	return bagSize
end

exports('GetPlayerMaxWeight', GetPlayerMaxWeight)

lib.callback.register('jungurum-smallresources:client:getBagSize', function()
    return GetPlayerMaxWeight()
end)
