local function findMostPopularChannel()
	-- Default to go to his home
	local party = piepan.channels(config.home)

	-- Find a group of users online
	for id,channel in pairs(table.ShuffleCopy(piepan.channels)) do
		-- Find the channel with the most users and don't stalk the person who originally triggered this event
		if #party:getUsers() <= #channel:getUsers() and channel ~= piepan.me.channel and channel.name ~= config.afk.channel then
			party = channel
		end
	end

	return party
end

hook.Add("OnUserLeftChannel", "Alone Checker", function(event)
	-- Find a group of people if everyone left DongerBot alone and go to them
	if #piepan.me.channel:getUsers() <= 1 then

		local party = findMostPopularChannel()

		-- Go
		piepan.me:moveTo(party)
		print(("[ALONE] Moving to: %q"):format(party.name))
	end
end)