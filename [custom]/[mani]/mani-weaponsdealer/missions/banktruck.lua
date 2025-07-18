local function BanktruckStart()
    local success, msg = lib.callback.await('mani-weaponsdealer:server:verifyBanktruckStart', false)
    if not success then lib.notify({ title = msg, type = 'error' }) return end

    lib.notify({ title = 'Missionen er aktiv', type = 'inform' })
end

return BanktruckStart