local dumpsterCooldowns = {}
local isSearching = false

local function SetupDumpsterTargets()
    for _, model in ipairs(Config.Dumpster) do
        exports.ox_target:addModel(model, {
            {
                name = 'dumpster_search',
                icon = 'fas fa-recycle',
                label = 'Undersøg skraldespand',
                distance = 1.5,
                onSelect = function(data)
                    if isSearching then
                        lib.notify({
                            title = 'Pant',
                            description = 'Du er allerede i gang med at søge i en skraldespand!',
                            type = 'error'
                        })
                        return
                    end

                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        lib.notify({
                            title = 'Pant',
                            description = 'Du kan ikke søge i skraldespanden fra et køretøj.',
                            type = 'error'
                        })
                        return
                    end

                    isSearching = true
                    local entity = data.entity
                    local coords = GetEntityCoords(entity)
                    local dumpsterKey = string.format("%.1f_%.1f_%.1f", coords.x, coords.y, coords.z)
                    lib.callback('pantsystem:server:checkDumpsterCooldown', false, function(onCooldown, timeLeft)
                        if onCooldown then
                            lib.notify({
                                title = 'Pant',
                                description = 'Denne skraldespand er blevet tømt for nyligt!',
                                type = 'error'
                            })
                            isSearching = false
                            return
                        end
                        
                        SearchDumpster(dumpsterKey)
                        isSearching = false
                    end, dumpsterKey)
                end,
                canInteract = function()
                    return true
                end
            }
        })
    end
end

function SearchDumpster(dumpsterKey)
    if IsPedInAnyVehicle(PlayerPedId(), true) then
        lib.notify({
            title = 'Pant',
            description = 'Du kan ikke søge i skraldespanden fra et køretøj.',
            type = 'error'
        })
        return
    end

    if IsEntityDead(PlayerPedId()) then
        return
    end

    if lib.progressBar({
        duration = Config.RecyclingSystem.SearchTime,
        label = 'Undersøger skraldespand...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
    }) then
        lib.callback('pantsystem:server:setDumpsterCooldown', false, function(success)
            if success then
                lib.callback('pantsystem:server:giveReward', false, function(result)
                    if not result.success then
                        lib.notify({
                            title = 'Pant',
                            description = 'Du fandt intet værdifuldt.',
                            type = 'error'
                        })
                        return
                    end
                    
                    if result.isCash then
                        lib.notify({
                            title = 'Pant',
                            description = 'Du fandt ' .. result.amount .. 'KR!',
                            type = 'success'
                        })
                    else
                        lib.notify({
                            title = 'Pant',
                            description = 'Du fandt ' .. result.amount .. 'x ' .. result.label .. '!',
                            type = 'success'
                        })
                    end
                end)
            end
        end, dumpsterKey)
    end
end

local function SetupRecyclingMachineTarget()
    exports.ox_target:addModel('pantmaskine', {
        {
            name = 'recycling_machine',
            icon = 'fas fa-recycle',
            label = 'Tilgå Pantautomat',
            distance = 2.0,
            onSelect = function()
                OpenRecyclingMenu()
            end,
            canInteract = function()
                return true
            end
        }
    })
end

function OpenRecyclingMenu()
    lib.callback('pantsystem:server:getRecyclableItemsWithCounts', false, function(recyclableItems)
        if not recyclableItems or #recyclableItems == 0 then
            lib.notify({
                title = 'Pantautomat',
                description = 'Ingen pantautomat er konfigureret.',
                type = 'error'
            })
            return
        end
        
        local totalCount = 0
        for _, item in ipairs(recyclableItems) do
            totalCount = totalCount + (item.count or 0)
        end

        local options = {}
        
        table.insert(options, {
            title = 'Recycle alle pant',
            description = totalCount > 0 
                and 'Recycle alt dit pant' 
                or 'Du har intet at pante',
            icon = 'fas fa-recycle',
            disabled = totalCount <= 0,
            onSelect = function()
                RecycleAllBottles()
            end
        })
        
        for _, item in ipairs(recyclableItems) do
            local hasItem = (item.count or 0) > 0
            table.insert(options, {
                title = item.label,
                description = hasItem
                    and 'Recycle ' .. item.count .. 'x ' .. item.label .. ' (Værdi: ' .. item.value .. 'KR. hver)'
                    or 'Du har intet at pante',
                icon = 'fas fa-wine-bottle',
                disabled = not hasItem,
                metadata = hasItem and {
                    {label = 'Antal', value = item.count},
                    {label = 'Værdi', value = item.count * item.value .. 'KR.'}
                } or nil,
                onSelect = function()
                    RecycleItem(item.name)
                end
            })
        end
        
        lib.registerContext({
            id = 'recycling_menu',
            title = 'Pantautomat',
            options = options
        })
        
        lib.showContext('recycling_menu')
    end)
end

function RecycleItem(itemName)
    lib.callback('pantsystem:server:recycleItem', false, function(success, amount, count)
        if success then
            lib.notify({
                title = 'Pantautomat',
                description = 'Du har recykleret ' .. count .. ' pant og modtaget en kvittering på ' .. amount .. 'KR.!',
                type = 'success'
            })
        else
            lib.notify({
                title = 'Pantautomat',
                description = 'Du har intet at pante',
                type = 'error'
            })
        end
    end, itemName)
end

function RecycleAllBottles()
    lib.callback('pantsystem:server:recycleAllItems', false, function(success, amount, totalCount)
        if success then
            lib.notify({
                title = 'Pantautomat',
                description = 'Du har recykleret ' .. totalCount .. ' pant og modtaget en kvittering på ' .. amount .. 'KR.!',
                type = 'success'
            })
        else
            lib.notify({
                title = 'Pantautomat',
                description = 'Du har intet at pante',
                type = 'error'
            })
        end
    end)
end

function SetupDepositLocations()
    for _, coords in ipairs(Config.DepositLocations) do
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = 1.5,
            debug = false,
            options = {
                {
                    name = 'deposit_receipts',
                    icon = 'fas fa-receipt',
                    label = 'Indløs pantkvitteringer',
                    distance = 2.0,
                    onSelect = function()
                        OpenDepositMenu()
                    end,
                    canInteract = function()
                        return true
                    end
                }
            }
        })
    end
end

function OpenDepositMenu()
    lib.callback('pantsystem:server:getReceiptItems', false, function(receipts)
        if not receipts or #receipts == 0 then
            lib.notify({
                title = 'Pantindløsning',
                description = 'Du har ingen pantkvitteringer at indløse.',
                type = 'error'
            })
            return
        end
        
        local options = {}
        
        for _, receipt in ipairs(receipts) do
            local value = receipt.metadata and receipt.metadata.value or 0
            local description = receipt.metadata and receipt.metadata.description or 'Pantkvittering'
            
            table.insert(options, {
                title = 'Pantkvittering',
                description = description,
                icon = 'fas fa-receipt',
                metadata = {
                    {label = 'Værdi', value = tostring(value) .. ' KR.'}
                },
                onSelect = function()
                    CashReceipt(receipt.slot)
                end
            })
        end
        
        lib.registerContext({
            id = 'deposit_menu',
            title = 'Pantindløsning',
            options = options
        })
        
        lib.showContext('deposit_menu')
    end)
end

function CashReceipt(slot)
    lib.callback('pantsystem:server:cashReceipt', false, function(success, amount)
        if success then
            lib.notify({
                title = 'Pantindløsning',
                description = 'Du har indløst din pantkvittering og modtaget ' .. amount .. ' KR.!',
                type = 'success'
            })
        else
            lib.notify({
                title = 'Pantindløsning',
                description = 'Der opstod en fejl ved indløsning af pantkvitteringen.',
                type = 'error'
            })
        end
    end, slot)
end

CreateThread(function()
    Wait(1000)
    SetupDumpsterTargets()
    SetupRecyclingMachineTarget()
    SetupDepositLocations()
end)
