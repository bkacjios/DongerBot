local DEBUG = false

local function debug(...)
	if DEBUG then
		print(...)
	end
end

dongerbot:hook("onServerVersion", function(event)
	debug("onServerVersion", event)
end)

dongerbot:hook("onServerReject", function(event)
	debug("onServerReject", event)
end)

dongerbot:hook("onServerSync", function(event)
	debug("onServerSync", event)
end)

dongerbot:hook("onServerPing", function()
	debug("onServerPing")
end)

dongerbot:hook("onChannelRemove", function(event)
	debug("onChannelRemove", event)
end)

dongerbot:hook("onChannelState", function(event)
	debug("onChannelState", event)
end)

dongerbot:hook("onUserRemove", function(event)
	debug("onUserRemove", event)
end)

dongerbot:hook("onUserState", function(event)
	debug("onUserState", event)
end)

dongerbot:hook("onMessage", function(event)
	debug("onMessage", event)
end)

dongerbot:hook("onPermissionDenied", function(event)
	debug("onPermissionDenied", event)
end)

dongerbot:hook("onCodecVersion", function(event)
	debug("onCodecVersion", event)
end)

dongerbot:hook("onUserStats", function(event)
	debug("onUserStats", event)
end)

dongerbot:hook("onServerConfig", function(event)
	debug("onServerConfig", event)
end)