Config = Config or {}
Config.ClothingScript = "rcore_clothing"
local compatible = { -- List of compatible clothing scripts (custom ones, don't add qb-clothing or esx_skins)
    "illenium-appearance",
    "rcore_clothing",
    "tgiann-clothing",
}

CreateThread(function()
    if compatible and next(compatible) then
        for i=1, #compatible do
            if GetResourceState(compatible[i]) ~= "missing" then
                Config.ClothingScript = compatible[i]
                break
            end
        end
    end
end)