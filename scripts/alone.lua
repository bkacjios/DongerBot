hook.Add("OnUserLeftChannel", "Alone Checker", function(event)
	-- Find a group of people if everyone left DongerBot alone and go to them
	if (event.changedChannelFrom == piepan.me.channel or event.isDisconnected) and #piepan.me.channel:getUsers() <= 1 then
		-- Default to go to his home
		local party = piepan.channels(config.home)

		-- Find a group of users online
		for id,channel in pairs(piepan.channels) do
			-- Find the channel with the most users and don't stalk the person who originally triggered this event
			if ( not party or #party:getUsers() <= #channel:getUsers() ) and channel ~= piepan.me.channel and channel ~= event.user.channel and channel.name ~= "AFK" then
				party = channel
			end
		end

		-- Go
		piepan.me:moveTo(party)
		print(("All alone, moving to: %q"):format(party.name))
		tts.speak("Hello!")
	end
end)