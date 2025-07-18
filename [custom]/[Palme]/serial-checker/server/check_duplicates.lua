ESX = exports["es_extended"]:getSharedObject()

local function extractSerialNumbers(inventoryData)
    local serials = {}
    if not inventoryData then return serials end
    
    if type(inventoryData) == "string" then
        inventoryData = json.decode(inventoryData)
    end

    if type(inventoryData) ~= "table" then return serials end
    
    for _, item in ipairs(inventoryData) do
        if item.metadata and item.metadata.serial then
            table.insert(serials, {
                serial = item.metadata.serial,
                weapon = item.name,
                slot = item.slot
            })
        end
    end
    return serials
end

local function sendToDiscord(duplicates)
    if #duplicates > 0 then
        local locationText = ""
        
        for _, dup in ipairs(duplicates) do
            locationText = locationText .. string.format("Serial: %s (Found %d times)\n", dup.serial, dup.count)
            for _, loc in ipairs(dup.locations) do
                if loc.source_type == "player" then
                    locationText = locationText .. string.format("- Player: %s, Weapon: %s, Slot: %d\n", 
                        loc.identifier, loc.weapon, loc.slot)
                else
                    locationText = locationText .. string.format("- Inventory: %s, Weapon: %s, Slot: %d\n", 
                        loc.inventory_name, loc.weapon, loc.slot)
                end
            end
        end

        exports.onl_logsender:SendLog("Console", locationText, {
            labels = {
                job = "logs",
                discordId = false,
                steamId = false,
                license = false,
                playerJob = false,
                jobGrade = false,
                playerName = false,
                screenshot = false,
                money = false,
                black_money = false,
                bank = false,
                coords = false,
                radio = false,
            },
            discordTitle = "Duplicate Weapon Serial Numbers Detected",
            discordWebhook = "https://discord.com/api/webhooks/1341716211670712395/9hcBraU0WuaO8W-afd3OyT4zZs6XOxMvzCrWkIj-nJBa5o5nX1oKSnRSLq7JqmocTw1g?thread_id=1347025017510166628"
        })
    end
end

local function checkDuplicateSerials()
    local allSerials = {}
    local duplicates = {}
    
    MySQL.query('SELECT identifier, inventory FROM users', {}, function(users)
        for _, user in ipairs(users) do
            local userSerials = extractSerialNumbers(user.inventory)
            for _, serialData in ipairs(userSerials) do
                if not allSerials[serialData.serial] then
                    allSerials[serialData.serial] = {
                        count = 1,
                        locations = {
                            {
                                source_type = "player",
                                identifier = user.identifier,
                                weapon = serialData.weapon,
                                slot = serialData.slot
                            }
                        }
                    }
                else
                    allSerials[serialData.serial].count = allSerials[serialData.serial].count + 1
                    table.insert(allSerials[serialData.serial].locations, {
                        source_type = "player",
                        identifier = user.identifier,
                        weapon = serialData.weapon,
                        slot = serialData.slot
                    })
                end
            end
        end

        MySQL.query('SELECT name, data FROM ox_inventory', {}, function(inventories)
            for _, inventory in ipairs(inventories) do
                local inventorySerials = extractSerialNumbers(inventory.data)
                for _, serialData in ipairs(inventorySerials) do
                    if not allSerials[serialData.serial] then
                        allSerials[serialData.serial] = {
                            count = 1,
                            locations = {
                                {
                                    source_type = "inventory",
                                    inventory_name = inventory.name,
                                    weapon = serialData.weapon,
                                    slot = serialData.slot
                                }
                            }
                        }
                    else
                        allSerials[serialData.serial].count = allSerials[serialData.serial].count + 1
                        table.insert(allSerials[serialData.serial].locations, {
                            source_type = "inventory",
                            inventory_name = inventory.name,
                            weapon = serialData.weapon,
                            slot = serialData.slot
                        })
                    end
                end
            end

            for serial, data in pairs(allSerials) do
                if data.count > 1 then
                    table.insert(duplicates, {
                        serial = serial,
                        count = data.count,
                        locations = data.locations
                    })
                end
            end
            
            if #duplicates > 0 then
                print("^1[WARNING] Found duplicate weapon serial numbers:^7")
                for _, dup in ipairs(duplicates) do
                    print(string.format("^1Serial: %s (Found %d times)^7", dup.serial, dup.count))
                    
                    for _, loc in ipairs(dup.locations) do
                        if loc.source_type == "player" then
                            print(string.format("  - Player: %s, Weapon: %s, Slot: %d", 
                                loc.identifier, loc.weapon, loc.slot))
                        else
                            print(string.format("  - Inventory: %s, Weapon: %s, Slot: %d", 
                                loc.inventory_name, loc.weapon, loc.slot))
                        end
                    end
                end
                sendToDiscord(duplicates)
            else
                print("^2[INFO] No duplicate weapon serial numbers found.^7")
            end
        end)
    end)
end

RegisterCommand('checkduplicates', function(source, args, rawCommand)
    if source == 0 then 
        checkDuplicateSerials()
    else
        print("^1[ERROR] This command can only be used in the server console^7")
    end
end, false)