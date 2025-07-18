local function generateInput(key)
    local input = lib.inputDialog('Hvidvaskeren', {
        {type = 'number', default = exports.ox_inventory:Search('count', Config.blackMoneyItem) or 0, label = 'Mængde', description = 'Mængde af sorte penge', required = true},
        {type = 'slider', min = Config.locations[key].minPercent, max = Config.locations[key].maxPercent, label = '%', description = 'Antal %', required = true},
        {type = 'input', label = 'Navn', description = 'navn på firma/person', required = true},
    })
    if input == nil then return end
    if input[1] <= 0 then return end
    TriggerServerEvent("sb_laundering:server:launderMoney", input[1], input[2], input[3], key)
end

local function generateTarget()
    for k, v in pairs(Config.locations) do
        exports.ox_target:addBoxZone({
            coords = vector3(v.coords.x, v.coords.y, v.coords.z),
            name = v.name,
            size = vector3(2, 2, 2),
            distance = 5,
            group = v.job,
            debug = false,
            rotation = v.coords.w,
            options = {
                {
                    label = "Åben hvidvask",
                    name = "launderingStart",
                    canInteract = function()
                        local xPlayer = ESX.GetPlayerData()
                        if v.jobs[xPlayer.job.name] then
                            if v.jobs[xPlayer.job.name] <= xPlayer.job.grade then
                                return true
                            end
                        end
                        return false
                    end,
                    onSelect = function()
                        generateInput(k)
                    end
                }
            }
        })
    end
end


CreateThread(function()
    generateTarget()
end)
        

