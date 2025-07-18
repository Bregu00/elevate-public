local DiscordAppId = tonumber(GetConvar("RichAppId", "1354791343175766251"))
local DiscordAppAsset = GetConvar("RichAssetId", "elevate")

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if LocalPlayer.state.name then
			Citizen.Wait(10000) 
			SetDiscordAppId(DiscordAppId)
			SetDiscordRichPresenceAsset(DiscordAppAsset)
			local playerId = GetPlayerServerId(PlayerId())
			SetRichPresence("["..GlobalState.PlayerCount.."/2048]\n".. LocalPlayer.state.name .. " | ID: " .. playerId .. "\n") 
			
			SetDiscordRichPresenceAction(0, "DISCORD.GG/ELEVATERP", "https://discord.gg/elevaterp")
		end
	end
end)



Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 21) then
            SetRelationshipBetweenGroups(2, 'player', 'player')
        end
        if IsControlJustReleased(0, 21) then
            SetRelationshipBetweenGroups(1, 'player', 'player')
        end
        Citizen.Wait(0)
    end
end)

