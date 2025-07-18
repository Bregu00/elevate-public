local model = `sf_prop_sf_headphones_dj`
local headphones = nil

function setHeadphones()
    if not Config.UseAnimation then return end
    lib.requestModel(model, 10000)
    CreateThread(function()
        playAnim("mp_masks@standard_car@ds@", "put_on_mask")
    end)
    headphones = CreateObject(model, GetEntityCoords(cache.ped), true, true, true)
    SetEntityCollision(headphones, false, true)
    AttachEntityToEntity(headphones, cache.ped, GetPedBoneIndex(cache.ped, 12844), 0.09, 0.03, 0.0, -20.0, 90.0, 0.0, true, true, false, false, 1, true)
end

function removeHeadphones()
    if not Config.UseAnimation then return end
    if headphones then
        playAnim("missheist_agency2ahelmet", "take_off_helmet_stand")
        DeleteObject(headphones)
        headphones = nil
    end
end

function playAnim(dict,anim)
    if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
	end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 49, 0.0, 0.0, 0.0, 0.0)
    Wait(1000)
    RemoveAnimDict(dict)
    ClearPedTasks(PlayerPedId())
end

-- AddEventHandler('ox_inventory:updateInventory', function(changes)
--     if not usingHeadphones then return end
--     local count = exports.ox_inventory:Search('count', Config.HeadphonesItem)
--     if not count or count == 0 and usingHeadphones then
--         TriggerEvent('av_music:removeHeadphones')
--     end
-- end)

-- RegisterNetEvent('QBCore:Player:SetPlayerData', function(player)
--     if not usingHeadphones then return end
--     if Config.Inventory == "ox_inventory" then return end
--     local items = player['items']
--     if not items then return end
--     local hasHeadphones = false
--     if items and next(items) then
--         for k, v in pairs(items) do
--             if v and v['name'] == Config.HeadphonesItem then
--                 hasHeadphones = true
--                 break
--             end
--         end
--     end
--     if not hasHeadphones then
--         TriggerEvent('av_music:removeHeadphones')
--     end
-- end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if headphones then
        DeleteObject(headphones)
        headphones = nil
    end
  end)