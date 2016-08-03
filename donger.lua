local mumble = require"mumble"
local ev = require"ev"
require"log"

local function loop()
	if not dongerbot  then
		dongerbot, err = mumble.connect("mbl27.gameservers.com", 10004, "config/dongerbot.pem", "config/dongerbot.key")
		--dongerbot, err = mumble.connect("raspberrypi.lan", 64738, "config/dongerbot.pem", "config/dongerbot.key")

		if dongerbot then
			log.info("Connected to server..")

			dongerbot:auth("DongerBot")

			log.info("Authenticated..")

			dofile("util.lua")
			autoreload.watch("util.lua")

			include("config.lua")

			includeDir("extensions/")
			includeDir("modules/")
			includeDir("scripts/")

			dongerbot:hook("onError", function(err)
				log.error(err)
			end)
		else
			-- Failed to connect.. try again in 5
			mumble.sleep(5)
		end
	elseif dongerbot and dongerbot:isConnected() then
		dongerbot:update()
	else
		dongerbot = nil
		log.warn("Disconnected from server.. (reconnect in 5 seconds)")
		mumble.sleep(5)
	end
end

evt = ev.IO.new( function()
	concommand.run(io.read())
end, 0, ev.READ )
evt:start( ev.Loop.default, false )

local timer = ev.Timer.new(loop, 0.01, 0.01 )
timer:start( ev.Loop.default )
ev.Loop.default:loop()
