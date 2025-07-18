RegisterNetEvent("jungurum-smallresources:server:giveIdCard", function()
    local src = source
    exports['jsfour-idcard']:CreateMetaLicense(src, 'id')
end)