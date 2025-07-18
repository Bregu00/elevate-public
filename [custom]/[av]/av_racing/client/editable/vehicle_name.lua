-- This file is for people who have addon vehicles and haven't registered them in Fivem client side, check the docs for more info
-- If you don't register your addon vehicles, they will be displayed as NULL in leaderboards
local myAddonVehicles = {
    -- spawnName = is the code that you use to spawn the code (example: sultan)
    -- label = the vehicle model that will be displayed in game
    {spawnName = "cazador", label = "BF Cazador TCR"}, 
    {spawnName = "rhinesed", label = "Rhinehart Sedan"}, 
    {spawnName = "str", label = "Benefactor Schneider STR"}, 
    {spawnName = "sr8", label = "Obey SR8 Elemento"}, 
    {spawnName = "srspback", label = "Obey Tailgater SR Hatchback"}, 
    {spawnName = "strcoupe", label = "Benefactor STR Coupe"}, 

}

CreateThread(function()
    for k, v in pairs(myAddonVehicles) do
	    AddTextEntry(v['spawnName'], v['label'])
    end
end)