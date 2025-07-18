local debug = true

function hasItem(item, amount)
    if amount == nil then
        amount = 1
    end

    local count = exports.ox_inventory:Search("count", item)
    
    return count >= amount
end

exports("hasItem", hasItem)

function debugPrint(message)
    if debug then
        print(message)
    end
end

exports("debugPrint", debugPrint)
