piepan.userchannel = piepan.userchannel or {}

function piepan.Channel:getUsers()
	local users = {}
	for name, channel in pairs(piepan.userchannel) do
		if channel == self then
			table.insert(users,piepan.users[name])
		end
	end
	return users
end

hook.Add("OnConnect", "Channel Users Init", function()
	for name,user in pairs(piepan.users) do
		piepan.userchannel[user.name] = user.channel
	end
end)

hook.Add("OnUserChange", "Channel Tracker", function(event)
	if event.isChangedChannel or event.isConnected then
		piepan.userchannel[event.user.name] = event.user.channel
		if event.user ~= piepan.me then
			if event.user.channel == piepan.me.channel then
				hook.Run("OnUserEnteredChannel", event)
			else
				hook.Run("OnUserLeftChannel", event)
			end
		end
	elseif event.isDisconnected then
		piepan.userchannel[event.user.name] = nil
		hook.Run("OnUserLeftChannel", event)
	end
end)