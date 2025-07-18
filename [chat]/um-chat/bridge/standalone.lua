local selectedFramework = require('config.chat').framework

if selectedFramework ~= 'standalone' then return end

---@param src integer
function GetPlayerJobsInfo(src)
    -- Code block
end

---@param src integer
---@param job string
---@return table
function GetFrameworkPlayersJob(src, job)
    --if GetPlayerJob(src) ~= job then return end
    return {} -- players
end

---@param src integer
function GetPlayerFirstName(src)
    return GetPlayerName(src)
end
