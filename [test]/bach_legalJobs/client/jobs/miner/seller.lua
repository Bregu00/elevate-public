local minerConfig = lib.load("shared.jobs.miner")
local isBusy = false
local initialized = false

local function openSellingMenu(location)
    if isBusy then
        lib.notify({
            description = "Du er allerede i gang med en handling",
            type = "error",
        })
        return
    end

    local isPremium = false
    if minerConfig["sellLocations"][location] and minerConfig["sellLocations"][location].premium then
        isPremium = true

    end

    local sellableItems = {}
    local playerItems = exports.ox_inventory:GetPlayerItems()

    for _, item in pairs(playerItems) do
        local basePrice = minerConfig["sellPrices"][item.name]

        if basePrice and item.count > 0 then
            local finalPrice = basePrice

            if isPremium and minerConfig["premiumMultiplier"][item.name] then
                finalPrice = math.floor(basePrice * minerConfig["premiumMultiplier"][item.name])
            end

            table.insert(sellableItems, {
                title = item.label,
                description = "Pris: " .. finalPrice .. ",- per enhed | Du har: " .. item.count,
                onSelect = function()
                    TriggerServerEvent("bach_legalJobs:sellItem", {
                        item = item.name,
                        label = item.label,
                        price = finalPrice,
                        location = location,
                    })
                end,
                metadata = {
                    {
                        label = "Pris",
                        value = finalPrice .. ",-",
                    },
                    {
                        label = "Beholdning",
                        value = item.count,
                    },
                },
            })
        end
    end

    if #sellableItems == 0 then
        lib.notify({
            description = "Du har ingen materialer at sælge",
            type = "error",
        })
        return
    end

    table.insert(sellableItems, 1, {
        title = "Sælg alle materialer",
        description = "Sælg alle dine sælgbare materialer på én gang",
        onSelect = function()
            lib.notify({
                description = "Sælger alle dine materialer...",
                type = "info",
                duration = 2000,
            })

            lib.callback.await("bach_legalJobs:sellAllItems", false, {
                premium = isPremium,
            })
        end,
        metadata = {
            {
                label = "Info",
                value = "Sælger alle materialer du har på dig",
            },
        },
    })

    lib.registerContext({
        id = "miner_selling_menu",
        title = "Materialesalg - " .. location,
        options = sellableItems,
    })

    lib.showContext("miner_selling_menu")
end

local function initSellerLocations()
    
    if initialized then
        return
    end

    if not minerConfig["sellLocations"] then
        return
    end

    for locationName, location in pairs(minerConfig["sellLocations"]) do

        if location.blip then
            local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, location.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, location.blip.scale)
            SetBlipColour(blip, location.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(locationName)
            EndTextCommandSetBlipName(blip)

        end

        local pedModel = location.pedModel or "a_m_y_business_01"

        CreateThread(function()
            
            if type(pedModel) == "string" then
                pedModel = GetHashKey(pedModel)
            end

            RequestModel(pedModel)

            local startTime = GetGameTimer()
            local timeout = false

            while not HasModelLoaded(pedModel) and not timeout do
                Wait(100)
                if GetGameTimer() - startTime > 10000 then
                    pedModel = GetHashKey("a_m_y_business_01")
                    RequestModel(pedModel)
                    startTime = GetGameTimer()

                    while not HasModelLoaded(pedModel) and GetGameTimer() - startTime < 10000 do
                        Wait(100)
                    end

                    if not HasModelLoaded(pedModel) then
                        timeout = true
                    end
                end
            end

            if not timeout then

                local coords = location.coords
                local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)

                SetEntityHeading(ped, coords.w)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)

                if location.scenario then
                    TaskStartScenarioInPlace(ped, location.scenario, 0, true)
                end

                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = "sell_materials",
                        icon = "fas fa-dollar-sign",
                        label = "Åben sælger menu",
                        distance = 2.5,
                        onSelect = function()
                            openSellingMenu(locationName)
                        end,
                    },
                })

            end

            SetModelAsNoLongerNeeded(pedModel)
        end)
    end

    initialized = true
end

RegisterNetEvent("bach_legalJobs:promptQuantity", function(data)
    local max = data.max or 1
    local item = data.item
    local price = data.price
    local label = data.label
    local location = data.location

    local input = lib.inputDialog("Angiv mængde", {
        {
            type = "number",
            label = "Hvor mange " .. label .. " vil du sælge?",
            description = "Pris per enhed: " .. price .. ",-",
            default = 1,
            min = 1,
            max = max,
            required = true,
        },
    })

    if input and input[1] then
        lib.callback.await("bach_legalJobs:confirmSale", false, {
            item = item,
            label = label,
            price = price,
            quantity = input[1],
            location = location,
        })
    else
        lib.notify({
            description = "Salg annulleret",
            type = "error",
        })
    end
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    Wait(3000) 
    initSellerLocations()
end)

exports("openSellingMenu", openSellingMenu)
