afk = {}

hook.Add("OnUserStats", "AFK Checker", function(event)
	local user = event.user
	local stats = event.stats

	-- DongerBot is immune
	if user == piepan.me then return end

	local afkchannel = piepan.channels(config.afk.channel)

	-- Ignore people in the AFK channel
	if user.channel == afkchannel then return end

	if stats.idlesecs > (config.afk.movetime * 60) - (config.afk.warning * 60) then
		if not user.warned then
			local idletime = math.floor(stats.idlesecs/60)
			local message = config.afk.warningmessage:format(idletime, config.afk.channel, config.afk.movetime - idletime)
			user:send(message)
			user.warned = true
			print(("[AFK] %s has been warned they are AFK"):format(user.name))
		end
	elseif user.warned then
		user.warned = false
		print(("[AFK] %s is no longer AFK"):format(user.name))
	end

	if stats.idlesecs > config.afk.movetime * 60 then
		print(("[AFK] %s was moved to %s"):format(user.name, config.afk.channel))
		user:moveTo(afkchannel)
	end
end)


function afk.checkstats()
	piepan.Timer.new(afk.checkstats, config.afk.checktime)
	for k,user in pairs(piepan.users) do
		user:requestStats()
	end
end

hook.Add("OnConnect", "AFK Start Timer", function()
	afk.checkstats()
end)