local mumble = require"mumble"
local ev = require"ev"
require"log"

math.randomseed(os.time())

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

			dongerbot:hook("OnError", function(err)
				log.error(err)
			end)

			dongerbot:hook("OnUserRemove", function(event)
				local user = event.user
				if user ~= dongerbot.me then return end
				log.warn(("%s from server (%q)"):format(event.ban and "Banned" or "Kicked", event.reason or "no reason"))
			end)
		else
			-- Failed to connect.. try again in 3
			mumble.sleep(3)
		end
	elseif dongerbot and dongerbot:isConnected() then
		dongerbot:update()
	else
		dongerbot = nil
		log.warn("Disconnected from server.. (reconnect in 3 seconds)")
		mumble.sleep(3)
	end
end

local evt = ev.IO.new( function()
	xpcall(function()
		concommand.run(io.read())
	end, function(err) 
		print(err)
		print(debug.traceback())
	end)
end, 0, ev.READ )
evt:start( ev.Loop.default, false )

local timer = ev.Timer.new(function()
	xpcall(loop, function(err)
		print(err)
		print(debug.traceback())
	end)
end, 0.01, 0.01 )
timer:start( ev.Loop.default )
ev.Loop.default:loop()

-- donger.lua:49: in main chunk