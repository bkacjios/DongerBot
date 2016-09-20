local function amIWithAMaster() -- Get a table of all masters
	local masters = {}
	for k,user in pairs(dongerbot.me:getChannel():getUsers()) do
		if user:isMaster() then
			table.insert(masters, user:getName())
		end
	end
	return #masters > 0, masters
end

command.Add("volume", function(ply, cmd, args)
	local volume = args[1]
	if volume then
		volume = tonumber(volume)/100
		if not ply:isMaster() then volume = math.min(volume,1) end
		dongerbot:setVolume(volume)
		log.info(("[COMMAND] %s: changed the volume to %i"):format(ply:getName(), volume*100))
	else
		ply:message(("Volume level: <b>%i</b>"):format(dongerbot:getVolume()*100))
	end
end, "Change the output volume of the bot")

command.Add( "goto", function( ply, cmd, args )
	local channel = dongerbot.me:getChannel()(args[1]) or dongerbot:getChannel(args[1])
	local user = dongerbot:getUser(args[1])
	if user then -- Default to a user
		dongerbot.me:move(user:getChannel())
		log.info(("[COMMAND] %s: sent me to %s"):format(ply:getName(), user:getName()))
	elseif channel then -- Fallback on a channel name
		dongerbot.me:move(channel)
		log.info(("[COMMAND] %s: sent me to %s"):format(ply:getName(), channel:getName()))
	else
		ply:message("Unable to find a target to go to.")
	end
end, "Make the bot go to a specific channel or user", true )

command.Add( "summon", function( ply, cmd, args )
	if ply:isMaster() then
		if ply:getChannel() == dongerbot.me:getChannel() then
			-- Already in a channel with a master
			ply:message(("Y-You didn't notice me %s?"):format(config.mastername))
		else
			ply:message(("I'm comming %s!"):format(config.mastername))
			dongerbot.me:move(ply:getChannel())
			log.info(("[COMMAND] %s: summoned me to %s"):format(ply:getName(), ply:getChannel():getName()))
		end
	else
		local leashed, with = amIWithAMaster()
		if leashed then
			ply:message(("I am already with my %s%s %s"):format(config.mastername, (#with>1 and "s: " or " "), table.concat(with, ", ")))
		else
			dongerbot.me:move(ply:getChannel())
			log.info(("[COMMAND] %s: summoned me to %s"):format(ply:getName(), ply:getChannel():getName()))
		end
	end
end, "Make the bot come to the channel you are in" )

command.Add( "fuckoff", function( ply, cmd, args )
	local leashed, with = amIWithAMaster()
	if not ply:isMaster() and leashed then
		ply:message(("I won't leave my %s%s %s"):format(config.mastername, (#with>1 and "s: " or " "), table.concat(with, ", ")))
	else
		dongerbot.me:move(dongerbot:getChannel(config.home))
		log.info(("[COMMAND] %s: told me to fuck off"):format(ply:getName()))
	end
end, "Make the bot go to his channel" )

command.Add( "mute", function( ply, cmd, args )
	ply:mute(true)
end, "Mute yourself", true )

command.Add( "unmute", function( ply, cmd, args )
	ply:mute(false)
end, "Unmute yourself", true )

command.Add( "hash", function( ply, cmd, args )
	if not args[1] then
		ply:message(("%s: %s"):format(ply:getName(), ply:getHash()))
	else
		local target = dongerbot:getUser(args[1])
		if target then
			ply:message(("%s: %s"):format(target:getName(), target:getHash()))
		else
			ply:message("User not found: " .. args[1])
		end
	end
end, "Get the hash of a user", true )

command.Add( "userid", function( ply, cmd, args )
	if not args[1] then
		ply:message(("%s: %s"):format(ply:getName(), ply:getID()))
	else
		local target = dongerbot:getUser(args[1])
		if target then
			ply:message(("%s: %s"):format(target:getName(), target:getID()))
		else
			ply:message("User not found: " .. args[1])
		end
	end
end, "Get the user id of a user", true )

command.Add( "channel", function( ply, cmd, args )
	ply:message("Your current channel ID: " .. ply:getChannel():getID())
end, "Get the channel ID of your current channel", true )