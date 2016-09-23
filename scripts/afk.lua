afk = {}

function afk.checkStats(event)
	local user = event.user

	local root = dongerbot:getChannel("."):getName()

	local afkchannel = dongerbot:getChannel(config.afk.channel[root])

	if user:getName() == "Amer" then
		afkchannel = dongerbot:getChannels()[30] or afkchannel 
	end

	-- Ignore people in the AFK channel
	if not afkchannel or user:getChannel() == afkchannel then return end

	local idle = event.idlesecs or 0

	if idle > config.afk.movetime * 60 then
		user:move(afkchannel)
		log.debug(("[AFK] %s was moved to %s"):format(user:getName(), afkchannel:getName()))
	elseif idle > (config.afk.movetime * 60) - (config.afk.warning * 60) then
		if not user.warned then
			local idletime = math.floor(idle/60)
			local message = config.afk.warningmessage:format(idletime, afkchannel:getName(), config.afk.movetime - idletime)
			user:message(message)
			user.warned = true
			log.debug(("[AFK] %s has been warned they are AFK"):format(user:getName()))
		end
	elseif user.warned then
		user.warned = false
		log.debug(("[AFK] %s is no longer AFK"):format(user:getName()))
	end
end

function afk.queryUsers()
	for k,user in pairs(dongerbot:getUsers()) do
		if user ~= dongerbot.me then
			user:requestStats()
		end
	end
end

dongerbot:hook("OnUserStats", "AFK Check", afk.checkStats)
dongerbot:hook("OnServerPing", "AFK Query Users", afk.queryUsers)