local Config = lib.load('config')

if not Config.Debug then return end

RegisterCommand('Debug:GiveArmor', function()
    local Ped = cache.ped
    SetPedArmour(Ped, 100)
end)
