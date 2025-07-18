ChatLoaded = false
local mouse = false
local config = require('config.chat')
local commandGeneral = config.commandGeneral

-- RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:addMode')
RegisterNetEvent('chat:removeMode')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

-- --deprecated, use chat:addMessage
-- AddEventHandler('chatMessage', function(author, color, text, tagData)
--   if not ChatLoaded then return end

--   Debug('chatMessage event', 'info')

--   local args = { text }

--   if author ~= "" then
--     table.insert(args, 1, author)
--   end

--   SendNUIMessage({
--     type = 'ON_MESSAGE',
--     data = {
--       args = args,
--       mode = '_global',
--     }
--   })
-- end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)

  Debug('serverPrint event', 'info')

  if msg == '' or msg == nil then return end


  SendNUIMessage({
    type = 'ON_MESSAGE',
    data = {
      templateId = 'print',
      multiline = true,
      args = { msg },
      mode = '_global'
    }
  })
end)

-- addMessage
local addMessage = function(message)
  if not ChatLoaded then Wait(1000) end

  Debug('Adding message', 'info')

  if type(message) == 'string' then
    message = {
      args = { message }
    }
  end

  Debug(message)

  SendNUIMessage({
    type = 'ON_MESSAGE',
    data = message
  })
end

exports('addMessage', addMessage)
AddEventHandler('chat:addMessage', addMessage)

-- addSuggestion
local addSuggestion = function(name, help, params)
  if not ChatLoaded then Wait(1000) end

  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    data = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end

exports('addSuggestion', addSuggestion)
AddEventHandler('chat:addSuggestion', addSuggestion)

AddEventHandler('chat:addSuggestions', function(suggestions)
  if not ChatLoaded then Wait(1000) end

  Debug('Adding suggestions', 'info')

  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      data = suggestion
    })
  end
end)


AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addMode', function(mode)
  SendNUIMessage({
    type = 'ON_MODE_ADD',
    mode = mode
  })
end)

AddEventHandler('chat:removeMode', function(name)
  SendNUIMessage({
    type = 'ON_MODE_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:clear', function()
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterCommand(config.clearCommand, function()
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

local function dataMessageExecute(msg)
  if msg:sub(1, 1) == commandGeneral.forwardSlash and #msg > 1 then
    ExecuteCommand(msg:sub(2))
    Debug('/Command entered: ' .. msg, 'info')
    return
  end
  if commandGeneral.onlyCommand.status then return end
  if #msg <= 1 then return end
  ExecuteCommand(commandGeneral.onlyCommand.executeChat .. ' ' .. tostring(msg))
  Debug('Message entered: ' .. msg, 'info')
end

local function typingDot(state)
  if not commandGeneral.typingDot.status then return end

  if not IsEntityVisible(cache.ped) then return end

  local pedCoords = GetEntityCoords(cache.ped)
  local nearbyPlayers = lib.getNearbyPlayers(pedCoords, 3, false)

  if #nearbyPlayers == 0 then return end

  TriggerServerEvent('um-chat:callback:typing', state)
end

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
      if IsAceAllowed(('command.%s'):format(command.name)) and command.name ~= 'openChat' then
        table.insert(suggestions, {
          name = '/' .. command.name,
          help = ''
        })
      end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end


AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)
  refreshCommands()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)
  refreshCommands()
end)

RegisterNUICallback('getConfig', function(_, cb)
  local nuiData = require('config.nui')
  cb({ data = nuiData })
  Wait(100)
  TriggerServerEvent('chat:init')
  refreshCommands()
  ChatLoaded = true
  Debug('Loaded', 'info')
end)

RegisterNUICallback('chatResult', function(data, cb)
  cb(1)
  SetNuiFocus(false, false)
  dataMessageExecute(data.message)
  typingDot(false)
end)

RegisterNUICallback('chatClose', function(_, cb)
  cb(1)
  mouse = false
  SetNuiFocus(false, false)
  Debug('Chat closed', 'info')
  typingDot(false)
end)

RegisterNUICallback('openMouse', function(_, cb)
  cb(1)
  mouse = not mouse
  SetNuiFocus(true, mouse)
  Debug('Mouse: ' .. tostring(mouse), 'info')
end)

RegisterKeyMapping('openChat', 'Open Chat', 'keyboard', 't')

RegisterCommand('openChat', function()
  if GetPauseMenuState() == 15 then return end

  if not ChatLoaded then
    return Debug('Chat waiting for nui', 'warn')
  end
  SendNUIMessage({ type = 'ON_OPEN' })
  SetNuiFocus(true, false)
  Debug('Chat opened', 'info')
  typingDot(true)
end, false)

CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false, false)
end)
