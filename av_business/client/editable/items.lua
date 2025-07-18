local currentProp = nil

RegisterNetEvent('av_business:consumable', function(metadata) -- consumable items like drinks, joints, food
    local ped = PlayerPedId()
    local type = metadata['type']
    local ingredients = metadata['ingredients']
    local prop = metadata['prop']
    if Config.Debug then
        print("^3[DEBUG]:^7 ".."av_business:consumable", type, prop, json.encode(ingredients))
    end
    local completed = doAnimation(prop)
    if completed and type then
        useEffects(ingredients, type)
    end
end)

RegisterNetEvent("av_business:box", function(metadata) -- boxes
    if not metadata or (not metadata.serial) then
        if Config.Debug then
            print("^3[DEBUG]:^7 ".."av_business:box received null instead of serial, make sure to craft the boxes using the business zones.")
        end
        return
    end
    local name = metadata.serial
    local label = metadata.description or metadata.serial
    exports['av_laptop']:openStash(name, label, Config.Boxes['weight'], Config.Boxes['slots'])
end)