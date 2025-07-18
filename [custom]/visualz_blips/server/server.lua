local groups = Config.groups

CreateThread(function()
  for groupName, groupData in pairs(groups) do
    groups[groupName].entities = {}
    groups[groupName].members = {}

    for entityModel, entityModelData in pairs(groupData.entitiyModels) do
      groups[groupName][entityModelData.name] = {
        nextUnitNumber = 1,
        availableUnitNumbers = {}
      }
    end
  end
end)

CreateThread(function()
  while true do
    Wait(1500)
    -- Loop through all groups
    for jobName, groupData in pairs(groups) do
      local blipData = {}

      -- Loop through all entities in the group
      for networkId, entityData in pairs(groupData.entities) do
        local entityNetworkId = NetworkGetEntityFromNetworkId(networkId)

        -- Check if the entity exists
        if groupData.entities[networkId] ~= nil then
          if DoesEntityExist(entityNetworkId) then
            -- Check if the entity needs to be deleted and break the loop
            if groupData.entities[networkId].delete == true then
              table.insert(groupData[groupData.entities[networkId].vehicleName].availableUnitNumbers,
                groupData.entities[networkId].unitNumber)
              groupData.entities[networkId] = nil
              blipData[networkId] = false
              UpdateServerEvent(jobName, groupData)
              return
            end

            local coords = GetEntityCoords(entityNetworkId)

            blipData[networkId] = {
              name = entityData.name,
              coords = coords,
              blip = groupData.entitiyModels[entityData.entityModelName].blip,
              model = entityData.entityModelName,
              entityModelGroupName = entityData.entityModelGroupName,
            }
          else
            table.insert(groupData[groupData.entities[networkId].entityModelGroupName].availableUnitNumbers,
              groupData.entities[networkId].unitNumber)
            groupData.entities[networkId] = nil
            blipData[networkId] = false
            UpdateServerEvent(jobName, g)
          end
        end
      end

      local xPlayers = ESX.GetExtendedPlayers("job", jobName)
      for _, xPlayer in pairs(xPlayers) do
        TriggerClientEvent('visualz_blips:client:updateBlip', xPlayer.source, blipData)
      end

      for _, shared_group in pairs(groupData.shared_groups) do
        if groups[shared_group] then
          local sharedPlayers = ESX.GetExtendedPlayers("job", shared_group)
          for _, sharedPlayer in pairs(sharedPlayers) do
            TriggerClientEvent('visualz_blips:client:updateBlip', sharedPlayer.source, blipData)
          end
        end
      end
      blipData = nil
    end
  end
end)

RegisterNetEvent('visualz_blips:server:addEntityToGroup')
AddEventHandler('visualz_blips:server:addEntityToGroup', function(groupName, type, networkId, unitName, unitNumber, unitCategory)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    if type == "vehicle" then
      local entityHandle = GetEntityFromNetworkIdFunc(networkId)
      if entityHandle == nil then
        TriggerClientEvent('ox_lib:notify', source, { type = 'error', title = 'Fejl, ERROR code 12: Kontakt PP for hjælp! med denne kode' })
        return
      end
      local tempEntityModel = GetEntityModel(entityHandle)

      for entityModel, entityModelData in pairs(groups[groupName].entitiyModels) do
        if GetHashKey(entityModel) == tempEntityModel then
          groups[groupName].entities[networkId] = {
            name = unitName .. " - " .. unitNumber,
            entityModelGroupName = entityModelData.name,
            entityModelName = entityModel,
            unitNumber = unitNumber,
            unitCategory = unitCategory,
            unitName = unitName,
          }
          break
        end
      end
    elseif type == "player" then
      local entityHandle = GetEntityFromNetworkIdFunc(networkId)
      if entityHandle == nil then
        return
      end

      if groups[groupName].entities[networkId] ~= nil then
        if groups[groupName].entities[networkId].unitNumber ~= nil then
          return
        end
      end

      if GetEntityType(entityHandle) == 1 then
        local entityModelData = groups[groupName].entitiyModels["player"]
        local unitNumbers = GetEntityModelNumber(groupName, entityModelData.name)

        groups[groupName].entities[networkId] = {
          name = entityModelData.name .. " - " .. unitNumbers.displayNumber,
          entityModelGroupName = entityModelData.name,
          entityModelName = "player",
          unitNumber = unitNumbers.unitNumber,
        }
      end
    end
  end
end)

ESX.RegisterServerCallback('visualz_blips:server:checkEntityGroup', function(source, cb, networkId)
    local foundGroup = nil
    local foundEntityData = nil

    for groupName, groupData in pairs(groups) do
        if groupData.entities[networkId] then
            foundGroup = groupName
            foundEntityData = groupData.entities[networkId]
            break
        end
    end

    if foundGroup and foundEntityData then
        cb(foundGroup, foundEntityData)
    else
        cb(nil, nil)
    end
end)

RegisterNetEvent('visualz_blips:server:goOnDuty')
AddEventHandler('visualz_blips:server:goOnDuty', function(groupName)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    groups[groupName].members[source] = {
      onDuty = true
    }
  end
end)

RegisterNetEvent('visualz_blips:server:goOffDuty')
AddEventHandler('visualz_blips:server:goOffDuty', function(groupName)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    groups[groupName].members[source] = {
      onDuty = false
    }
  end
end)

RegisterNetEvent('esx:setJob', function(source, job)
  TriggerClientEvent("visualz_blips:client:resetBlips", source)
end)

RegisterNetEvent('visualz_blips:server:removeEntityFromGroup')
AddEventHandler('visualz_blips:server:removeEntityFromGroup', function(groupName, networkId)
  local source = source
  local player = ESX.GetPlayerFromId(source)

  if player.job.name == groupName then
    local entityData = groups[groupName].entities[networkId]
    if entityData then
      table.insert(groups[groupName][entityData.entityModelGroupName].availableUnitNumbers, entityData.unitNumber)
      groups[groupName].entities[networkId] = nil
      TriggerClientEvent('visualz_blips:client:removeBlip', source, networkId)
    end
  end
end)

function GetEntityFromNetworkIdFunc(networkId)
  local timeout = 2

  local entity = NetworkGetEntityFromNetworkId(networkId)
  repeat
    Wait(500)
    timeout = timeout - 1
    entity = NetworkGetEntityFromNetworkId(networkId)
    if timeout == 0 then
      return nil
    end
  until
    entity > 0
  return entity
end

function GetEntityModelNumber(groupName, vehicleName)
  local groupData = groups[groupName][vehicleName]
  local entityUnitNumber
  local displayNumber

  if #groupData.availableUnitNumbers > 0 then
    table.sort(groupData.availableUnitNumbers)
    entityUnitNumber = table.remove(groupData.availableUnitNumbers, 1)
  else
    entityUnitNumber = groupData.nextUnitNumber
    groupData.nextUnitNumber = groupData.nextUnitNumber + 1
  end

  if tonumber(entityUnitNumber) < 10 then
    displayNumber = 0 .. entityUnitNumber
  else
    displayNumber = entityUnitNumber
  end

  return {
    unitNumber = entityUnitNumber,
    displayNumber = displayNumber
  }
end

lib.callback.register('elevate_police:getAvailablePatrolId', function(source)
    local usedIds = {}

    for _, groupData in pairs(groups) do
        for _, entityData in pairs(groupData.entities) do
            if entityData.unitNumber then
                local id = tonumber(entityData.unitNumber:match('10%-(%d+)'))
                if id then
                    usedIds[id] = true
                end
            end
        end
    end

    for i = 20, 999 do
        if not usedIds[i] then
            return i
        end
    end

    return nil
end)