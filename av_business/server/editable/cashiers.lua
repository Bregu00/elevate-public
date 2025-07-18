-- Use this function to calculate the employee commission or return false to use default values
function getCommission(customer, employee, job, account, total)
    local commission = false

    return commission -- return number or false
end


lib.callback.register("av_business:server:getNearbyPlayers", function(source)
    local radius = 5.0
    local sourcePed = GetPlayerPed(source)
    if not sourcePed or not DoesEntityExist(sourcePed) then
        return {}
    end
    local sourceCoords = GetEntityCoords(sourcePed)
    local nearbyPlayers = {}
    local allPlayers = lib.getNearbyPlayers(sourceCoords, radius)
    for i = 1, #allPlayers do
        local playerId = allPlayers[i].id
        if playerId ~= source then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                table.insert(nearbyPlayers, {
                    value = playerId,
                    label = xPlayer.getName() -- Get character's name via ESX
                })
            end
        end
    end
    return nearbyPlayers
end)