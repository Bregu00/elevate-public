function GetGender()
    return lib.callback.await('mani-bridge:server:getGender', false)
end

exports('GetGender', GetGender)