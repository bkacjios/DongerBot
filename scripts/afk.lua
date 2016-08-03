afk = {}

function afk.checkStats(event)
	local user = event.user

	local afkchannel = dongerbot:getChannel(config.afk.channel)

	-- Ignore people in the AFK channel
	if not afkchannel or user.channel == afkchannel then return end

	if event.idlesecs > (config.afk.movetime * 60) - (config.afk.warning * 60) then
		if not user.warned then
			local idletime = math.floor(event.idlesecs/60)
			local message = config.afk.warningmessage:format(idletime, config.afk.channel, config.afk.movetime - idletime)
			user:message(message)
			user.warned = true
			log.info(("[AFK] %s has been warned they are AFK"):format(user.name))
		end
	elseif user.warned then
		user.warned = false
		log.info(("[AFK] %s is no longer AFK"):format(user.name))
	end

	if event.idlesecs > config.afk.movetime * 60 then
		user:move(afkchannel)
		log.info(("[AFK] %s was moved to %s"):format(user.name, config.afk.channel))
	end
end

function afk.queryUsers()
	for k,user in pairs(dongerbot:getUsers()) do
		if user ~= dongerbot.me then
			user:requestStats()
		end
	end
end

dongerbot:hook("onUserStats", "AFK Check", afk.checkStats)
dongerbot:hook("onServerPing", "AFK Query Users", afk.queryUsers)