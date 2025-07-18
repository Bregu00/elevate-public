local DoShit = false

if not DoShit then return end

local HashList = {
    [GetHashKey('zx10r')] = 'zx10r',
}

local blacklistedItems = {
    ['mods_list'] = true,
    ['id'] = true,
    ['photo'] = true,
    ['weapon_petrolcan'] = true,
}

MySQL.ready(function()
    MySQL.query('SELECT `vehicle`, `owner`, `glovebox`, `trunk`, `id` FROM `owned_vehicles`', function(response)
        if response then
            for i = 1, #response do
                local vehicle = json.decode(response[i].vehicle)
                if HashList[vehicle.model] then
                    local price = exports['jungurum-lib']:getVehicleFromHash(vehicle.model).price
                    local webhookMessage = ('Køretøj: %s | Pris: %s | Ejer: %s'):format(HashList[vehicle.model], ESX.Math.GroupDigits(price), response[i].owner)
                    PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({content = webhookMessage}), {['Content-Type'] = 'application/json'})

                    local trunk = json.decode(response[i].trunk) or {}
                    local glovebox = json.decode(response[i].glovebox) or {}
                    local refundItems = {}

                    for i = 1, #trunk do
                        if not blacklistedItems[trunk[i].name] then
                            refundItems[trunk[i].name] = trunk[i].count
                        end
                    end

                    for i = 1, #glovebox do
                        if not blacklistedItems[glovebox[i].name] then
                            refundItems[glovebox[i].name] = glovebox[i].count
                        end
                    end

                    if refundItems['money'] then
                        refundItems['money'] = refundItems['money'] + price
                    else
                        refundItems['money'] = price
                    end

                    if next(refundItems) then
                        MySQL.insert('INSERT INTO `refunds` (identifier, items) VALUES (?, ?)', {
                            response[i].owner, json.encode(refundItems)
                        })
                    end

                    Wait(1000)

                    MySQL.query.await('DELETE FROM `owned_vehicles` WHERE `id` = ?', {
                        response[i].id,
                    })

                    Wait(1000)
                end
            end
        end

        print('Refund Done On Vehicles:')
    end)

    for k, v in pairs(HashList) do
        local data = exports['jungurum-lib']:getVehicleFromHash(k)

        if data then
            print(('%s %s'):format(data.brand, data.model))

            MySQL.query.await('DELETE FROM `dealership_vehicles` WHERE `hashkey` = ?', {
                k,
            })
        end
    end
end)