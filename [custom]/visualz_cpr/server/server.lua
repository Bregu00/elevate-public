-- Tabel til at gemme sidste dødsårsag for hver spiller
local lastDeathCause = {}

-- Event der fanger spillerens død og gemmer dødsårsagen
RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local victimId = source
    local victimPlayer = ESX.GetPlayerFromId(victimId)

    if victimPlayer.getMeta('causeOfDeath') ~= nil then
        return
    end
    local causeOfDeath = data.deathCause ~= 0 and data.deathCause or GetPedCauseOfDeath(GetPlayerPed(victimId))
    victimPlayer.setMeta('causeOfDeath', causeOfDeath)
end)

-- Callback til at forsøge CPR
lib.callback.register('visualz_cpr:attemptRevive', function(source, target)
    local src = source
    local xTarget = ESX.GetPlayerFromId(target)
    local distance = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))

    -- Afstandstjek
    if distance > Config.Distance then
        return { type = 'error', description = 'Du er for langt væk fra personen' }
    end

    -- Spilleren må ikke være død selv
    if Player(src).state.dead then
        return { type = 'error', description = 'Denne handling er ikke mulig' }
    end

    -- Tjek om målet er død
    if not Player(target).state.dead then
        return { type = 'error', description = 'Personen er ikke død' }
    end

    -- Hent spillerens sidste dødsårsag fra `esx:onPlayerDeath`
    local causeOfDeath = xTarget.getMeta('causeOfDeath') or nil
    -- Tjek om spilleren døde af skud eller kniv
    if causeOfDeath and Config.forbiddenWeapons[causeOfDeath] then
        return { type = 'error', description = 'CPR kan ikke bruges på personer, der er blevet skudt eller stukket ihjel.' }
    end

    -- CPR Animation
    TriggerClientEvent('visualz_cpr:reviveAnimation', src)
    Wait(9000)

    -- Bestem om CPR lykkes
    local success = math.random(1, 100) <= Config.Chance

    if success then
        TriggerClientEvent('ars_ambulancejob:healPlayer', target, { revive = true })
        local logMsg = ('[%s] %s | Blev genoplivet af [%s] %s'):format(target, GetPlayerName(target), src, GetPlayerName(src))
        exports['onl_logsender']:SendLog(src, logMsg, {
            labels = {
                job = "logs",
                discordId = true,
                steamId = true,
                license = true,
                playerJob = true,
                jobGrade = true,
                playerName = true,
                screenshot = false,
                money = false,
                black_money = false,
                bank = false,
                coords = true,
                radio = false,

            },
            discordTitle = logMsg,
            discordWebhook = "https://discord.com/api/webhooks/1354849245194223800/CDtE2W5MafskVYc1tzzlZmxTqb4XYiEfPLz5iCsGvOgF23ra9zCH_4ucg-GSiIbjE3Eq?thread_id=1354849226416459881" -- Another webhook
        })

        return { type = 'success', description = 'Du har genoplivet personen' }
    end

    return { type = 'error', description = 'Du har fejlet med at genoplive personen' }
end)

-- Funktion til at tjekke om en værdi findes i et array (forbiddenCauses)
function table.includes(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then return true end
    end
    return false
end

lib.callback.register("visualz_cpr:server:CanBeRevived", function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local causeOfDeath = xPlayer.getMeta('causeOfDeath') or nil
    if causeOfDeath and Config.forbiddenWeapons[causeOfDeath] then
        return false
    end
    return true
end)

RegisterNetEvent('visualz_cpr:server:clearCauseOfDeath', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.clearMeta('causeOfDeath')
end)
