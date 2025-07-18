local cache = {}
local ready = false

CreateThread(function()
    MySQL.ready(function()
        MySQL.query('SELECT * FROM elevate_confidential', function(response)
            if response then
                for i = 1, #response do
                    local row = response[i]
                    cache[row.key] = row.data
                end
            end
            ready = true
        end)
    end)
end)

exports('fetch', function(key)
    while not ready do Wait(100) end
    return cache[key]
end)

-- CREATE TABLE `elevate_confidential` (
-- 	`key` VARCHAR(24) NOT NULL DEFAULT '' COLLATE 'utf8mb3_general_ci',
-- 	`data` TEXT NOT NULL COLLATE 'utf8mb3_general_ci',
-- 	PRIMARY KEY (`key`) USING BTREE
-- )
-- COLLATE='utf8mb3_general_ci'
-- ENGINE=InnoDB
-- ;