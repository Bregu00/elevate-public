Config = Config or {}
Config.RepairKit = "camera_kit" -- Item used to repair cameras
Config.RepairDistance = 10 -- Distance to repair a camera
Config.VehicleJammer = 'cam_jammer' -- Used to block camera signal in vehicles
Config.Items = {
    ['gopro'] = { -- item name
        canUse = function() -- add yourn own check to allow player to use this item (it runs client side)
            return true -- return true or false
        end,
        settings = {
            prop = `prop_spycam`, -- prop hash or false
            battery = 48, -- (in hours) or true to make it permanent
            rotation = false, -- allow rotation, can be: true, false or "full"
            nightvision = true, -- night vision?
            thermal = false, -- thermal vision?
            canDestroy = true, -- if cam gets shot it will be permanently deleted
            vehicle = true, -- can be installed in vehicles?
            job = false, -- can be installed as Job camera?
        }
    },
    ['security_cam'] = { -- item name
        canUse = function() -- add yourn own check to allow player to use this item (it runs client side)
            return true -- return true or false
        end,
        settings = {
            prop = false, -- prop hash or false
            battery = true, -- (in hours) or true to make it permanent
            rotation = 'full', -- allow rotation, can be: true, false or "full"
            nightvision = true, -- night vision?
            thermal = true, -- thermal vision?
            canDestroy = false, -- if cam gets shot it will be permanently deleted
            vehicle = false, -- can be installed in vehicles?
            job = true, -- can be installed as Job camera?
        }
    },
}