local function findMostPopularChannel()
	-- Default to go to his home
	local party = dongerbot:getChannel(config.home)

	-- Find a group of users online
	for id,channel in pairs(table.ShuffleCopy(dongerbot:getChannels())) do
		-- Find the channel with the most users and don't stalk the person who originally triggered this event
		if #party:getUsers() <= #channel:getUsers() and channel ~= dongerbot.me.channel and channel.name ~= config.afk.channel then
			party = channel
		end
	end

	return party
end

dongerbot:hook("onUserState", "Alone Checker", function(event)
	local user = event.user

	if user.channel_from ~= dongerbot.me.channel then
		return
	end

	-- Find a group of people if everyone left DongerBot alone and go to them
	if #dongerbot.me.channel:getUsers() <= 1 then
		local party = findMostPopularChannel()

		-- Go
		dongerbot.me:moveTo(party)
	end
end)