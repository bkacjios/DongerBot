local fuckers = {
	["cada9419e57b953f62eeeca471686a2041f032bd"] = true, -- Noodle
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
}

hook.Add("OnUserEnteredChannel", "Welcome People", function(event)
	local user = event.user
	if not piepan.Audio.isPlaying() then
		-- Insult some specific people at a random chance
		if fuckers[user.hash] and math.random(1,4) == 4 then
			tts.speak(table.Random(insults):format(user.name))
		else
			tts.speak(table.Random(greetings):format(user.name))
		end
	end
end)