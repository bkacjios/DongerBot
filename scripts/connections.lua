dongerbot:hook("OnUserRemove", "Connect Log", function(event)
	if event.user == dongerbot.me then return end

	local message = ("User %s %s from server"):format(event.user:getName(), event.ban and "banned" or event.actor and "kicked" or "disconnected")
	
	if event.reason then
		message = message .. (" (%s)"):format(event.reason)
	end

	log.info(message)
end)

dongerbot:hook("OnUserConnected", "Disconnect Log", function(event)
	log.info(("User %s connected to the server"):format(event.user:getName()))
end)
