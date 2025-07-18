exports("oxy", function(data, slot)
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)

    if health >= maxHealth then
        lib.notify({
            description = "Du har allerede fuldt liv",
            duration = 5000,
            type = "error",
        })
        return
    end

    local success = lib.progressBar({
        duration = 3000,
        label = "Tager Oxy",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = false,
            move = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
        },

    })

    if not success then
        StopAnimTask(playerPed, dict, anim, 1.0)
        return
    end

    lib.callback.await("jungurum-smallresources:removeOxy", false)

    local totalHealed = 0
    local targetHeal = 10

    CreateThread(function()
        while totalHealed < targetHeal do
            health = GetEntityHealth(playerPed)

            if health >= maxHealth then
                break
            end

            local healAmount = 2
            if health + healAmount > maxHealth then
                healAmount = maxHealth - health
            end

            if totalHealed + healAmount > targetHeal then
                healAmount = targetHeal - totalHealed
            end

            SetEntityHealth(playerPed, health + healAmount)
            totalHealed = totalHealed + healAmount

            if totalHealed >= targetHeal then
                break
            end

            Wait(1000)
        end
    end)
end)

RegisterCommand("1health", function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)

    SetEntityHealth(playerPed, 120)
end)
