local DEBUG = false

local function debug(...)
	if DEBUG then
		print(...)
	end
end

dongerbot:hook("OnServerVersion", function(event)
	debug("onServerVersion", event)
end)

dongerbot:hook("OnServerReject", function(event)
	debug("onServerReject", event)
end)

dongerbot:hook("OnServerSync", function(event)
	debug("onServerSync", event)
end)

dongerbot:hook("OnServerPing", function(event)
	--debug("onServerPing", event)
end)

dongerbot:hook("OnChannelRemove", function(event)
	debug("onChannelRemove", event)
end)

dongerbot:hook("OnChannelState", function(event)
	debug("onChannelState", event)
end)

dongerbot:hook("OnUserRemove", function(event)
	debug("onUserRemove", event)
end)

dongerbot:hook("OnUserState", function(event)
	debug("onUserState", event)
	--for k,v in pairs(dongerbot:getUsers()) do print(k,v) end
end)

dongerbot:hook("OnMessage", function(event)
	debug("onMessage", event)
end)

dongerbot:hook("OnPermissionDenied", function(event)
	debug("onPermissionDenied", event)
end)

dongerbot:hook("OnCodecVersion", function(event)
	debug("onCodecVersion", event)
end)

dongerbot:hook("OnUserStats", function(event)
	--debug("onUserStats", event)
end)

dongerbot:hook("OnServerConfig", function(event)
	debug("onServerConfig", event)
end)