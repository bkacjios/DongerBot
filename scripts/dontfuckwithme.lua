hook.Add( 'OnUserChange', 'FUCKYOU', function(event)
	local user = event.user
	local actor = event.actor

	if user == piepan.me and actor ~= user then
		if user.isServerMuted then
			actor:mute(true)
			user:mute(false)
			tts.speak("You can't mute the donger!")
			print(("%s attempted to mute the donger"):format(actor.name))
		elseif user.isServerDeafened then
			actor:deafen(true)
			user:deafen(false)
			tts.speak("You can't deafen the donger!")
			print(("%s attempted to deafen the donger"):format(actor.name))
		elseif event.isChangedChannel and not actor:isMaster() then
			if actor.channel == event.changedChannelFrom then
				actor:send("If you want gone, you must tell me to <b>!fuckoff</b>")
			else
				actor:send("If you want me, you must <b>!summon</b> me")
			end
			user:moveTo(event.changedChannelFrom)
			print(("%s attempted to move the donger"):format(actor.name))
		end
	end
end )