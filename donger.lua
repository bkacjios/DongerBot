local mumble = require"mumble"
log = require"log"

if not dongerbot then
	dongerbot = assert(mumble.new("config/dongerbot.pem", "config/dongerbot.key"))
	--assert(dongerbot:connect("raspberrypi.lan"))
	assert(dongerbot:connect("mbl27.gameservers.com", 10004))
end

dofile("util.lua")
autoreload.watch("util.lua")
dofile("config.lua")
autoreload.watch("config.lua")

include("debug.lua")
include("command.lua")

includeDir("extensions/")
includeDir("scripts/")

dongerbot:auth("DongerBot")

dongerbot:hook("onError", function(err)
	log.error(err)
end)

while dongerbot do
	dongerbot:update()
	mumble.sleep(0.01)
end