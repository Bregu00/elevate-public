-- Auto Message
local autoMessage = require('config.automessage')

if not autoMessage.status then return end

local maxLenght, step = #autoMessage.messageList, 1

---@param index number
local function autoChatMessageEvent(index)
    TriggerClientEvent('chat:addMessage', -1, {
        args = autoMessage.messageList[index],
        tag = {
            name = autoMessage.tag.name,
            background = autoMessage.tag.background
        },
    })
end

local function setAutoMessageTable()
    if maxLenght == 1 then autoChatMessageEvent(step) return end

    if autoMessage.steps then
        autoChatMessageEvent(step)
        step = (step % maxLenght) + 1
        return
    end

    for i = 1, maxLenght do
        autoChatMessageEvent(i)
    end
end

CreateThread(function()
    Wait(5000)
    while autoMessage.status do
        Wait(autoMessage.interval)
        setAutoMessageTable()
    end
end)