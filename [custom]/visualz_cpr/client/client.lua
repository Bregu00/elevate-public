local performing
exports.ox_target:addGlobalPlayer({
    {
        name = 'cppr',
        icon = 'fas fa-hands-helping',
        label = 'CPR Personen',
        distance = Config.Distance,
        onSelect = function(data)
            local target = NetworkGetPlayerIndexFromPed(data.entity)
            performing = true
            if not target or target == -1 then
                lib.notify({ type = 'error', description = 'CPR kan ikke udføres på denne person.' })
                return
            end

            local targetServerId = GetPlayerServerId(target)

            if not targetServerId or targetServerId <= 0 then
                lib.notify({ type = 'error', description = 'Kunne ikke finde spillerens server ID.' })
                return
            end

            local attempt = lib.callback.await('visualz_cpr:attemptRevive', false, targetServerId)
            performing = false
            lib.notify(attempt)
        end,
        canInteract = function(entity)  
            if performing == nil or performing == false then
                local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                local data = lib.callback.await('ars_ambulancejob:getData', false, targetServerId)
                local isDead = data.status.isDead
                return isDead
            else
                return false
            end
        end
    }
})

RegisterNetEvent('visualz_cpr:reviveAnimation')
AddEventHandler('visualz_cpr:reviveAnimation', function()
    local playerPed = PlayerPedId()
    local cpr_str = "mini@cpr@char_a@cpr_str"
    local cpr_def = "mini@cpr@char_a@cpr_def"

    if not HasAnimDictLoaded(cpr_str) then
        RequestAnimDict(cpr_str)
        while not HasAnimDictLoaded(cpr_str) do
            Wait(10)
        end
    end

    if not HasAnimDictLoaded(cpr_def) then
        RequestAnimDict(cpr_def)
        while not HasAnimDictLoaded(cpr_def) do
            Wait(10)
        end
    end

    TaskPlayAnim(playerPed, cpr_def, "cpr_intro", 8.0, 1.0, -1, 2, 0, false, false, false)
    Wait(2000)
    TaskPlayAnim(playerPed, cpr_str, "cpr_pumpchest", 8.0, 1.0, -1, 9, 0, false, false, false)
    Wait(7000)
    TaskPlayAnim(playerPed, cpr_def, "cpr_success", 8.0, 1.0, -1, 2, 0, false, false, false)
    
    RemoveAnimDict(cpr_str)
    RemoveAnimDict(cpr_def)
end)
