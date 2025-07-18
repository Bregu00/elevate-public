Config = Config or {}
Config.DistanceUnit = "miles" -- "KM" or "miles" (To modify the text in UI go to av_laptop/build/lang.json and search distance_unit)
Config.BlipColor = 50 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
Config.Blips = { -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
    Route = {color = 6},
    Generic = { Size = 1.0, Color = 38 },
    Next = { Size = 1.3, Color = 47 },
    Passed = { Size = 0.6, Color = 62 }
}
Config.CheckpointSound = true -- Trigger a sound when u reach a waypoint
Config.PositionsUpdateTime = 1 -- In seconds, how often it will sync the race leaderboard (increase the number if using a low-end server machine)
Config.FlareTime = 10 -- In seconds
Config.StartAndFinishModel = `prop_offroad_tyres02`
Config.CheckpointPileModel = `xm_prop_base_tripod_lampa`
Config.MinimumCheckpoints = 5 -- Minimum Checkpoints required for a race
Config.JoinDistance = 100 -- Distance between player and race to join
Config.MaxTimeDNF = 5 -- Max time (in minutes) players have to complete the race after the 1st place has finish it, all the racers who haven't completed it will be marked as DNF.
Config.EventExpirationTime = 5 -- Max time (in minutes) before removing an event that has reached it starting time and has not being started
Config.RouteDistance = 150 -- It won't render the route in GPS if the distance between your current checkpoint and the next one is less than X meters.
Config.AllowPassengers = true -- Allow passengers to join races and see checkpoints/UI, they don't have to pay any money and they won't receive anything if they are in the winning vehicle
Config.WinnersPrizes = { -- Divide the prize pot with the 1st, 2nd and 3rd place from a total of 100%
    [1] = 70, --% Percentage for 1st place
    [2] = 20, --% Percentage for 2nd place
    [3] = 10, --% Percentage for 3rd place
    -- The total from all places can't be more than 100%, otherwise the script will ignore your values and give the 100% to 1st place and 0 to all other places
}
Config.WaypointsToRender = 3 -- Amount of checkpoint waypoints to render during a race
Config.MinRacersRecord = 10 -- In order to update a player record, the race needs at least X racers competing, otherwise no records (races / wins) will be updated for anyone in race
Config.LightPropsToRender = 10 -- Amount of light props to render at the same time
Config.MaxBlipsRender = 15 -- blips to render at the same time, to prevent the 100 limit from GTA
-- "lights": https://bzzz.tebex.io/package/5834472
-- "flags": https://bzzz.tebex.io/package/6459195
-- false: it will use default GTA 5 lamps and tyres 
Config.CustomCheckpoints = "flags" -- string or false
Config.Models = {
    ["flags"] = {
        ["start"] = `bzzz_start_d`,
        ["finish"] = `bzzz_finish_c`,
        ["checkpoint"] = 'bzzz_checkpoint_'
    },
    ["lights"] = {
        ["start"] = Config.StartAndFinishModel,
        ["finish"] = Config.StartAndFinishModel,
        ["checkpoint"] = 'bzzz_prop_light_tube_'
    },
}