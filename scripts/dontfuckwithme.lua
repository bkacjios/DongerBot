dongerbot:hook("OnUserState", "DONT FUCK WITH ME", function(event)
	if not dongerbot.me then return end
	
	local user = event.user
	local actor = event.actor

	if user == dongerbot.me and actor ~= user then
		if user.deaf then
			actor:setDeaf(true)
			user:setDeaf(false)
			log.debug(("[FuckOFF] %s attempted to deafen the donger"):format(actor:getName()))
		elseif user.mute then
			actor:setMuted(true)
			user:setMuted(false)
			log.debug(("[FuckOFF] %s attempted to mute the donger"):format(actor:getName()))
		--[[elseif event.channel and not actor:isMaster() then
			if actor.channel == event.channel_from then
				actor:send("If you want me gone, you must tell me to <b>!fuckoff</b>")
			else
				actor:send("If you want me, you must <b>!summon</b> me")
			end
			user:moveTo(event.channel_from)
			log.debug(("[FuckOFF] %s attempted to move the donger"):format(actor:getName()))]]
		end
	end
end )