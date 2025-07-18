Config = {}

function Config.ShowNotification(msg)
end

function Config.helpNotify(msg)
end

Config.UseHelpNotify = false

Config.PlaceSettings = { ---- distance settings
    radiusWhenVehicle = 2.5,
    radiusWhenPedOrSurface = 15.0
}

Config.RopeSettings = {
    MaxLenght = 2.5,
    MinLenght = 2.5,
    Type = 6, --- https://docs.fivem.net/natives/?_0xE832D760399EB220 more types here
}

Config.Lang = 'en'

Config.Labels = {
    ['en'] = {
        pedToPed = 'Du kan ikke gøre dette.',
        theSame = 'Du kan ikke gøre dette.',
        toFar = 'Du er for langt væk!',
        doing = "Du er igang med noget andet.",
        unTie = "Løsne snoren",
        helpNotify = 'Tryk E for at bind snoren, X for at afbryde'
    }
}

Config.Target = 'ox_target' --- or qb-target
Config.Framework = 'ESX' ------ ESX/QBCORE/QBOX (you can add more in editable_server.lua)
Config.Inventory = 'esx' ---- esx/qb-inventory/qbox/custom --- custom means that your inventory system have items.lua file where you can add items example ox_inventory

Config.Item = 'rope'
Config.RaycastColor = {255, 255, 255}
Config.RaycastAlpha = 125