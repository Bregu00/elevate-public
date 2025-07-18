lib.callback.register('elevate-impound:server:getImpoundedVehicles', function(source, job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local impoundedVehicles = {}
    local vehicles = {}
    if job == 'police' then
        vehicles = MySQL.query.await('SELECT * FROM `impounded_vehicles`')
    else
        vehicles = MySQL.query.await('SELECT * FROM `impounded_vehicles` WHERE `owner` = ?', { xPlayer.getIdentifier() })
    end
    if not vehicles then
        return {}
    end
    for _, vehicle in ipairs(vehicles) do
        table.insert(impoundedVehicles, {
            VehicleLabel = vehicle.vehicle_label,
            Plate = vehicle.plate,
            ReleaseTime = vehicle.release_time,
            Reason = vehicle.reason,
            Price = vehicle.price
        })
    end
    return impoundedVehicles
end)

function GetVehicleOwner(plate)
    local result = MySQL.query.await('SELECT owner FROM `owned_vehicles` WHERE plate = ?', { plate })
    if result and #result > 0 then
        return result[1].owner
    else
        return nil
    end
end


local function deleteVehicle(netid)
    local vehicle = NetworkGetEntityFromNetworkId(netid)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end
ESX.RegisterServerCallback('elevate-impound:server:impoundVehicle', function(source, cb, vehicleTable)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isPoliceImpound = vehicleTable.isPoliceImpound
    local plate = vehicleTable.plate
    local trunk = exports.ox_inventory:GetInventoryItems("trunk"..plate) or nil
    local glovebox = exports.ox_inventory:GetInventoryItems("glove"..plate) or nil
    deleteVehicle(vehicleTable.vehicle)
    if not isPoliceImpound then return cb(false, "Bilen er blevet beslaglagt og kan hentes i opbevaring") end
    local owner = GetVehicleOwner(plate)
    if not owner then return cb(false, "Bilen er ikke ejet af nogen.") end
    local releaseTime = os.time() + ((60 * 60 * 24) * vehicleTable.release_time)
    local reason = vehicleTable.reason
    local vehicleProps = json.encode(vehicleTable.vehicledata)
    local trunkData = trunk and json.encode(trunk) or nil
    local gloveboxData = glovebox and json.encode(glovebox) or nil
    local vehicleDealerShipData = exports["jungurum-lib"]:getVehicleFromHash(vehicleTable.vehicledata.model)
    local price = (vehicleDealerShipData.price * (vehicleTable.priceProcent / 100)) or 0
    local vehicleLabel = vehicleDealerShipData ~= nil and vehicleDealerShipData.brand .. " " .. vehicleDealerShipData.model or nil
    MySQL.Async.execute('INSERT INTO `impounded_vehicles` (vehicle_label, plate, release_time, reason, price, owner, vehicledata, trunk, glovebox) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        vehicleLabel ~= nil and vehicleLabel or vehicleTable.vehicledata.model,
        plate,
        releaseTime,
        reason,
        price,
        owner,
        vehicleProps,
        trunkData,
        gloveboxData
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.execute('DELETE FROM `owned_vehicles` WHERE plate = ?', { plate }, function(rowsChanged2)
                if rowsChanged2 > 0 then
                    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(owner)
                    local email = exports["lb-phone"]:GetEmailAddress(phoneNumber)
                    local success, id = exports["lb-phone"]:SendMail({
                        to = email,
                        sender = "Politi",
                        subject = "Bilen er blevet opbevaret",
                        message = "Din " .. vehicleLabel .. " med nummerplade " .. plate .. " er blevet opbevaret af politiet. Du kan hente den om " .. vehicleTable.release_time .. " dage ved at betale et gebyr på " .. price .. "DKK.",
                    })
                    if success then
                        print("Mail sent successfully with ID: " .. id)
                    else
                        print("Failed to send mail.")
                    end
                    exports.onl_logsender:SendLog(source, xPlayer.getName() .. " har impounded et køretøj med nummerpladen " .. plate .. " i " .. vehicleTable.release_time .. " Dage", {
                        labels = {
                            job = "logs",
                            discordId = true,
                            steamId = true,
                            license = true,
                            playerJob = true,
                            jobGrade = true,
                            playerName = true,
                            screenshot = true,
                            money = true,
                            black_money = true,
                            bank = true,
                            coords = true,
                            radio = true,
            
                        },
                        fileContent = "Baggagerum" .. (trunkData or "") .. "\n" .. "Handskerum" .. (gloveboxData or ""),
                        fileName = "carTrunkAndGloveData.txt",
                        discordTitle = "Politi beslaglæggelse",
                        discordWebhook = "https://discord.com/api/webhooks/1367510592360812554/9kEmhtgTXzraWStrZ6m_0Q7zRoYdR1MG-AxQi1QadNkCsG0GMX_huTiug7rke--DR08C" -- Another webhook
                    })
                    return cb(true, "Bilen er blevet transportet til politi opbevaring og er låst i " .. vehicleTable.release_time .. " dage. Du skal betale " .. price .. "DKK for at få den tilbage.")
                else
                    return cb(false, "Bilen kunne ikke opbevares")
                end
            end)
        else
            return cb(false, "Bilen kunne ikke opbevares")
        end
    end)
end)

ESX.RegisterServerCallback('elevate-impound:server:releaseVehicle', function(source, cb, plate, job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local vehicle = MySQL.query.await('SELECT * FROM `impounded_vehicles` WHERE plate = ?', { plate })
    if not vehicle or #vehicle == 0 then
        return cb(false)
    end
    local releaseTime = vehicle[1].release_time
    local currentTime = os.time()
    local price = vehicle[1].price
    if exports["fh_accountclose"]:isAccountLocked(src) then return cb(false) end
    if xPlayer.getAccount('bank').money <= price then
        return cb(false)
    end
    if not job == "police" and currentTime > releaseTime then return cb(false) end
    MySQL.Async.execute('DELETE FROM `impounded_vehicles` WHERE plate = ?', { plate }, function(rowsChanged)
        if rowsChanged > 0 then
            local trunkData = vehicle[1].trunk and json.decode(vehicle[1].trunk) or nil
            local gloveboxData = vehicle[1].glovebox and json.decode(vehicle[1].glovebox) or nil
            local vehicleProps = json.decode(vehicle[1].vehicledata)
            local owner = vehicle[1].owner
            MySQL.Async.execute('INSERT INTO `owned_vehicles` (owner, plate, vehicle, type, stored, glovebox, trunk, impounded, parked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                owner,
                plate,
                json.encode(vehicleProps),
                "car",
                "global",
                gloveboxData and json.encode(gloveboxData) or nil,
                trunkData and json.encode(trunkData) or nil,
                0,
                1
            }, function(rowsChanged2)
                if rowsChanged2 > 0 then
                    exports.onl_logsender:SendLog(source, xPlayer.getName() .. " har released et køretøj med nummerpladen " .. plate, {
                        labels = {
                            job = "logs",
                            discordId = true,
                            steamId = true,
                            license = true,
                            playerJob = true,
                            jobGrade = true,
                            playerName = true,
                            screenshot = true,
                            money = true,
                            black_money = true,
                            bank = true,
                            coords = true,
                            radio = true,
            
                        },
                        fileContent = "Baggagerum" .. (vehicle[1].trunk or "") .. "\n" .. "Handskerum" .. (vehicle[1].glovebox or ""),
                        fileName = "carTrunkAndGloveData.txt",
                        discordTitle = "Politi beslaglæggelse",
                        discordWebhook = "https://discord.com/api/webhooks/1367510592360812554/9kEmhtgTXzraWStrZ6m_0Q7zRoYdR1MG-AxQi1QadNkCsG0GMX_huTiug7rke--DR08C" -- Another webhook
                    })
                    return cb(true)
                else
                    return cb(false)
                end
            end)
        else
            return cb(false)
        end
    end)
end)

lib.callback.register("elevate-impound:server:isVehicleOwned", function(source, plate)
    local result = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE plate = ?', { plate })
    if result and #result > 0 then
        return true
    else
        return false
    end
end)

-- MySQL.ready(function()
--     local query = [[
--         CREATE TABLE IF NOT EXISTS impounded_vehicles (
--             id INT AUTO_INCREMENT PRIMARY KEY,
--             vehicle_label VARCHAR(255) NOT NULL,
--             plate VARCHAR(255) NOT NULL,
--             release_time DATETIME NOT NULL,
--             reason VARCHAR(255) NOT NULL,
--             price INT NOT NULL,
--             owner VARCHAR(255) NOT NULL
--         )
--     ]]
--     MySQL.Async.execute(query)
-- end)