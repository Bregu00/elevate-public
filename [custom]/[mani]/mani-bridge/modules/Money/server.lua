local function ConvertMoneyType(moneyType)
    if moneyType == 'money' and Config.Framework == 'qb' or Config.Framework == 'qbx' then
        return 'cash'
    elseif moneyType == 'cash' and Config.Framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

local function canAfford(src, moneyTypes, amount)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        for i = 1, #moneyTypes do
            local moneyType = ConvertMoneyType(moneyTypes[i])
            if PlayerData.getAccount(moneyType).money >= amount then
                return true, moneyType
            end
        end
        return false
    elseif Config.Framework == 'qb' or Framework == 'qbx' then
        for i = 1, #moneyTypes do
            local moneyType = ConvertMoneyType(moneyTypes[i])
            if PlayerData.Functions.GetMoney(moneyType) >= amount then
                return true, moneyType
            end
        end
        return false
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('canAfford', canAfford)

local function AddMoney(src, moneyType, amount)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        PlayerData.addAccountMoney(ConvertMoneyType(moneyType), amount)
    elseif Config.Framework == 'qb' or Framework == 'qbx' then
        PlayerData.Functions.AddMoney(ConvertMoneyType(moneyType), amount)
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('AddMoney', AddMoney)

local function RemoveMoney(src, moneyType, amount)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        PlayerData.removeAccountMoney(ConvertMoneyType(moneyType), amount)
    elseif Config.Framework == 'qb' or Framework == 'qbx' then
        PlayerData.Functions.RemoveMoney(ConvertMoneyType(moneyType), amount)
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('RemoveMoney', RemoveMoney)