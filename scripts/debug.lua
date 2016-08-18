local DEBUG = false

local function debug(...)
	if DEBUG then
		print(...)
	end
end

dongerbot:hook("OnServerVersion", function(event)
	debug("OnServerVersion", event)
end)

dongerbot:hook("OnServerReject", function(event)
	debug("OnServerReject", event)
end)

dongerbot:hook("OnServerSync", function(event)
	debug("OnServerSync", event)
end)

dongerbot:hook("OnServerPing", function(event)
	--debug("OnServerPing", event)
end)

dongerbot:hook("OnChannelRemove", function(event)
	debug("OnChannelRemove", event)
end)

dongerbot:hook("OnChannelState", function(event)
	debug("OnChannelState", event)
end)

dongerbot:hook("OnUserRemove", function(event)
	debug("OnUserRemove", event)
end)

dongerbot:hook("OnUserState", function(event)
	debug("OnUserState", event)
	--for k,v in pairs(dongerbot:getUsers()) do print(k,v) end
end)

dongerbot:hook("OnMessage", function(event)
	debug("OnMessage", event)
end)

dongerbot:hook("OnPermissionDenied", function(event)
	debug("OnPermissionDenied", event)
end)

dongerbot:hook("OnCodecVersion", function(event)
	debug("OnCodecVersion", event)
end)

dongerbot:hook("OnUserStats", function(event)
	--debug("OnUserStats", event)
end)

dongerbot:hook("OnServerConfig", function(event)
	debug("OnServerConfig", event)
end)

dongerbot:hook("OnAudioFinished", function()
	debug("OnAudioFinished")
end)