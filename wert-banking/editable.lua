-- If you use another target system edit export codes
CreateThread(function()
	-- exports["qb-target"]:AddTargetModel(Config.AtmModels, {
    --     options = {
    --         {
	-- 			type = "client",
	-- 			event = "qb-banking:target-openBankScreen",
	-- 			place = "Banka",
	-- 			icon = "fab fa-cc-visa",
	-- 			label = LANG["targetatmlabel"],
	-- 		},
    --     },
    --     distance = 1.5
    -- })
    -- for k,v in pairs(Config.TargetBankLocations) do
    --     exports["qb-target"]:AddBoxZone(k.."BankTargets", vector3(v.x, v.y, v.z), 1.0, 2.7, {
    --         name=k.."BankTargets",
    --         heading=v.w,
    --         debugPoly=false,
    --         minZ=v.z-0.5,
    --         maxZ=v.z+0.5
    --         }, {
    --             options = {
    --                 {
                        
    --                     type = "client",
	-- 			        event = "qb-banking:target-openBankScreen",
	-- 			        place = "Banka",
	-- 			        icon = "fab fa-cc-visa",
	-- 			        label = LANG["targetbanklabel"],
    --                 },
    --             },
    --         distance = 1.5
    --     })
    -- end
    -- If you use ox_target enable this
    exports.ox_target:addModel(Config.AtmModels, {
        {
            name = 'wert-bank:option1',
            event = "qb-banking:target-openBankScreen",
            icon = "fa-solid fa-credit-card",
			label = LANG["targetatmlabel"],
        },
    })
    for k,v in pairs(Config.TargetBankLocations) do
        exports.ox_target:addBoxZone({
            coords = vector3(v.x, v.y, v.z),
            size = vec3(3, 3, 3),
            rotation = v.w,
            options = {
                {
                    name = 'wert-bank:option2',
                    event = "qb-banking:target-openBankScreen",
                    icon = "fa-solid fa-credit-card",
				    label = LANG["targetbanklabel"],
                }
            }
        })
    end
end)