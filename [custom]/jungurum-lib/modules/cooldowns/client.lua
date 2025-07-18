exports('GetGangCooldown', function()
    return lib.callback.await('jungurum-lib:server:getGangCooldown', false)
end)

exports('SetGangCooldown', function(misType, time)
    return lib.callback.await('jungurum-lib:server:setGangCooldown', false, misType, time)
end)

exports('GetAllGangCooldowns', function(gang)
    return lib.callback.await('jungurum-lib:server:GetAllGangCooldowns', false, gang)
end)