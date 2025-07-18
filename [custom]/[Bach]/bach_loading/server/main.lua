RegisterNetEvent("bach_loading:shutdown", function()
    local src = source

    deferrals.handover({
        shutdown = true,
    })
end)
