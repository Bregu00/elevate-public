local bridgeResources = {
    ["ND_Core"] = "nd",
    ["ox_core"] = "ox",
    ["es_extended"] = "esx",
    ["qb-core"] = "qb"
}

local function getBridge()
    for resource, framework in pairs(bridgeResources) do
        if GetResourceState(resource):find("start") then
            return ("bridge.%s.%s"):format(framework, lib.context)
        end
    end
    return ("bridge.standalone.%s"):format(lib.context)
end

Bridge = require(getBridge())

Tablet = {}

Tablet.VehicleBlipLabels = {
    ["polargento"] = "Bravo",
    ["polbenefacgt"] = "Bravo",
    ["poliwagen"] = "Bravo",
    ["polrebla"] = "Bravo",
    ["polodyssey"] = "Bravo",
    ["polrhinehart"] = "Bravo",
    ["polimperial"] = "Lima",
    ["polckomoda"] = "Mike-Kilo",
    ["polcschafter3"] = "Kilo",
    ["polctailgater2"] = "Mike-Kilo",
    ["polcrhinehart"] = "Mike-Kilo",
    ["polcbuffaloh"] = "Kilo",
    ["polcbenefacgt"] = "Kilo",
    ["polcgresleyh"] = "Kilo",
    ["polshinobi"] = "Mike",
    ["polbf400"] = "Mike",
    ["polcxls"] = "Romeo",
    ["polstreiter"] = "Bravo",
    ["polxls"] = "Bravo",
    ["politiboat"] = "Bravo",
    ["dinghy3"] = "Bravo",
    ["poljugular"] = "Bravo",
    ["polraiden"] = "Bravo",
    ["polcneon"] = "Kilo",
    ["polcraiden"] = "Kilo",
    ["polcargento"] = "Mike-Kilo",
    ["polcimperial"] = "Romeo",
    ["polmav"] = "Foxtrot",
    ["polcshinobi"] = "Mike",
}

Tablet.IsValidBlipVehicle = function(model)
    for vehicle in pairs(Tablet.VehicleBlipLabels) do
        local hash = GetHashKey(vehicle)
        if hash == model then return true end
    end

    return false
end

Tablet.GetVehicleBlipName = function(model)
    for vehicle, label in pairs(Config.VehicleBlipLabels) do
        local hash = GetHashKey(vehicle)
        if hash == model then return label end
    end

    return nil
end
