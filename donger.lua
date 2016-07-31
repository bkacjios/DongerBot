local mumble = require"mumble"
log = require"log"

if not dongerbot then
	dongerbot = assert(mumble.new("config/dongerbot.pem", "config/dongerbot.key"))
	--assert(dongerbot:connect("raspberrypi.lan"))
	assert(dongerbot:connect("mbl27.gameservers.com", 10004))
end

dofile("util.lua")
dofile("config.lua")
autoreload.watch("donger.lua")
autoreload.watch("util.lua")
autoreload.watch("config.lua")

include("command.lua")

includeDir("extensions/")
includeDir("scripts/")

dongerbot:auth("DongerBot")

dongerbot:hook("onServerVersion", function(event)
	print("onServerVersion", event)
end)

dongerbot:hook("onServerReject", function(event)
	print("onServerReject", event)
end)

local encoder = mumble.encoder()

dongerbot:hook("onServerSync", function(event)
	print("onServerSync", event)
end)

dongerbot:hook("onServerPing", function()
	print("onServerPing")
end)

dongerbot:hook("onChannelRemove", function(event)
	print("onChannelRemove", event)
end)

dongerbot:hook("onChannelState", function(event)
	print("onChannelState", event)
end)

dongerbot:hook("onUserRemove", function(event)
	print("onUserRemove", event)
end)

dongerbot:hook("onUserState", function(event)
	print("onUserState", event)
end)

dongerbot:hook("onMessage", function(event)
	print("onMessage", event)
end)

dongerbot:hook("onPermissionDenied", function(event)
	print("onPermissionDenied", event)
end)

dongerbot:hook("onCodecVersion", function(event)
	print("onCodecVersion", event)
end)

dongerbot:hook("onUserStats", function(event)
	print("onUserStats", event)
end)

dongerbot:hook("onServerConfig", function(event)
	print("onServerConfig", event)
end)

dongerbot:hook("onError", function(err)
	log.error(err)
end)

while true do
	dongerbot:update()
	mumble.sleep(0.01)
end