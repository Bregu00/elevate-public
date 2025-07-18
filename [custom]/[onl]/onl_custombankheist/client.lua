giveitem = function(item, amount)
    TriggerServerEvent('onl_custombankheist:giveItem', item, amount)
end

moneyItem = function(amount)
    TriggerServerEvent('onl_custombankheist:giveMoney', amount)
end

giveVehicle = function(model)
    TriggerServerEvent('onl_custombankheist:giveVehicle', model)
end

addReward = function(amount)
    TriggerServerEvent('onl_custombankheist:addReward', amount)
end