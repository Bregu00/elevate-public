RegisterCommand("handling", function(source, args)
    -- if IsPlayerAceAllowed(source, "ONLHandlingEditor") then
        TriggerClientEvent("ONLHandlingEditor", source, args)
    -- end
end, true)