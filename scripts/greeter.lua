local fuckers = {
	["3a2faf14aa4135f6cfe2c642aaa0b8cc4a97b6cc"] = true, -- Noodle
	["ace706de79dba0218df641ff44499ea5bd0331ad"] = true, -- Davey
}

local insults = {
	"Eat shit and die, %s!",
	"Nobody likes you %s!",
	"Fuck you %s!",
}

local greetings = {
	"Greetings %s!",
	"Hello %s!",
	"Hi %s!",
	"Welcome %s!",
	"Welcome back %s!",
	"Hola %s!",
}

local timemessage = "Good %s %s!"
local hour = tonumber(os.date("%H"))

hook.Add("OnUserEnteredChannel", "Welcome People", function(event)
	local user = event.user

	if not piepan.Audio.isPlaying() and math.random(1,100) == 100 then
		soundboard.playsound("lol")
	end

	if math.random(1,4) == 4 then
		if user:isMaster() then
			piepan.me.channel:send(table.Random(greetings):format(user.name))
		elseif fuckers[user.hash] then
			if math.random(1,3) == 3 then
				local message = "morning"

				if hour <= 23 and hour >= 17 then
					message = "evening"
				elseif hour < 17 and hour >= 12 then
					message = "afternoon"
				end

				piepan.me.channel:send(timemessage:format(message, user.name))
			else
				piepan.me.channel:send(table.Random(insults):format(user.name))
			end
		end
	end
end)