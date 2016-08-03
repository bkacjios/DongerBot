local mumble = require"mumble"
log = require"log"

while true do
	dongerbot, err = mumble.connect("mbl27.gameservers.com", 10004, "config/dongerbot.pem", "config/dongerbot.key")
	--dongerbot, err = mumble.connect("raspberrypi.lan", 64738, "config/dongerbot.pem", "config/dongerbot.key")

	if dongerbot then
		log.info("Connected to server..")

		dongerbot:auth("DongerBot")

		log.info("Authenticated..")

		dofile("util.lua")
		autoreload.watch("util.lua")

		include("config.lua")
		include("command.lua")

		includeDir("extensions/")
		includeDir("scripts/")

		dongerbot:hook("onError", function(err)
			log.error(err)
		end)

		while dongerbot:isConnected() do
			dongerbot:update()
			mumble.sleep(0.01)
		end

		log.warn("Disconnected from server.. (reconnect in 5 seconds)")
	end

	mumble.sleep(5);
end