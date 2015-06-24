hook.Add( 'OnMessage', 'STFU', function(event)
	local msg = event.text
	if msg:lower() == "stfu" then
		-- Check if the current audio is youtube audio and check if the user has access
		if not config.youtube.userSTFU and youtube.Playing and not event.user:isMaster() then
			event.user:send("You don't have permission to STFU a youtube video, use !voteskip instead.")
			return
		end
		piepan.Audio.stop() -- SILENCE
	end
end)