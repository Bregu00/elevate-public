SvConfig = {
    Inv = "ox", -- qb(=lj) or ox [Inventory system]
    webhook = "https://discord.com/api/webhooks/1338382705850847272/H1SjJasdoHUU-JJ5Zti1Pa6MT8tcgcBD5qrqj-dTjPVO_1dAYN2U04nvlVdYvdMyzsJy?thread_id=1338382678004731974", -- Add Discord webhook
    FivemerrApiToken = 'pJxaJGFVo0hDWW3VVFKxnMwPs46Dc2e3',
}
local function ConfigInvInvalid()
    print('^1[Error] Your SvConfig.Inv isnt set.. you probably had a typo\nYou have it set as= SvConfig.Inv = "'.. SvConfig.Inv .. '"')
end

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent('ps-camera:requestFivemerrToken', function(Key)
    local source = source
    local event = ("ps-camera:grabbed%s"):format(Key)
    TriggerClientEvent(event, source, SvConfig.FivemerrApiToken)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent("ps-camera:getStreetName", source, url, coords)
end)

RegisterNetEvent("ps-camera:savePhoto", function(url, streetName)
    
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local location = streetName

    local info = {
        ps_image = url,
        location = location
    }

    local ox_inventory = exports.ox_inventory
    
    if ox_inventory:CanCarryItem(source, 'photo', 1) then
        local embed = {
            {
                ["title"] = "Photo Taken",
                ["description"] = "**Player:** " .. xPlayer.getName() .. "\n" .. "**license:** " .. xPlayer.getIdentifier(),
                ["color"] = 3447003,
                ["image"] = {
                    ["url"] = json.decode(url)
                },
                ["footer"] = {
                    ["text"] = "Photo uploaded via ps-camera",
                }
            }
        }
        PerformHttpRequest(SvConfig.webhook, function(err, text, headers) end, "POST", json.encode({
            username = "ps-camera",
            embeds = embed
        }), {["Content-Type"] = "application/json"})
        ox_inventory:AddItem(source, "photo", 1, info)
    end
end)

lib.callback.register("ps-camera:server:getItemSlotData", function(source, slot)
    return exports.ox_inventory:GetSlot(source, slot)
end)
