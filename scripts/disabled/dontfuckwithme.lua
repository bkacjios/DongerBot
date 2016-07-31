dongerbot:hook("onUserState", "DONT FUCK WITH ME", function(event)
	local user = event.user
	local actor = event.actor

	if user == dongerbot.me and actor ~= user then
		if user.mute then
			actor:mute(true)
			user:mute(false)
			log.debug(("[FuckOFF] %s attempted to mute the donger"):format(actor.name))
		elseif user.deaf then
			actor:deafen(true)
			user:deafen(false)
			log.debug(("[FuckOFF] %s attempted to deafen the donger"):format(actor.name))
		elseif event.channel and not actor:isMaster() then
			if actor.channel == event.channel_from then
				actor:send("If you want me gone, you must tell me to <b>!fuckoff</b>")
			else
				actor:send("If you want me, you must <b>!summon</b> me")
			end
			user:moveTo(event.channel_from)
			log.debug(("[FuckOFF] %s attempted to move the donger"):format(actor.name))
		end
	end
end )