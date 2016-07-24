local function amIWithAMaster() -- Get a table of all masters
	local masters = {}
	for k,user in pairs(piepan.me.channel:getUsers()) do
		if user:isMaster() then
			table.insert(masters, user.name)
		end
	end
	return #masters > 0, masters
end

command.Add("volume", function(ply, args)
    local volume = args[1]
    if volume then
        volume = tonumber(volume)/100
        if not ply:isMaster() then volume = math.min(volume,1) end
        piepan.Audio.setVolume(volume)
        print(("[COMMAND] %s: changed the volume to %i"):format(ply.name, volume*100))
    else
    	ply:send(("Volume is currently at %i"):format(piepan.Audio.getVolume()*100))
    end
end, "Change the output volume of the bot")

command.Add( "goto", function( ply, args )
	local channel = piepan.channels(args[1])
	local user = piepan.users[args[1]]
	if user then -- Default to a user
		piepan.me:moveTo(user.channel)
		print(("[COMMAND] %s: sent me to %s"):format(ply.name, user.name))
	elseif channel then -- Fallback on a channel name
		piepan.me:moveTo(channel)
		print(("[COMMAND] %s: sent me to %s"):format(ply.name, user.channel.name))
	else
		ply:send("Unable to find a target to go to.")
	end
end, "Make the bot go to a specific channel or user", true )

command.Add( "summon", function( ply, args )
	if ply:isMaster() then
		if ply.channel == piepan.me.channel then
			-- Already in a channel with a master
			ply:send(("Y-You didn't notice me %s?"):format(config.mastername))
		else
			ply:send(("I'm comming %s!"):format(config.mastername))
			piepan.me:moveTo(ply.channel)
			print(("[COMMAND] %s: summoned me to %s"):format(ply.name, ply.channel.name))
		end
	else
		local leashed, with = amIWithAMaster()
		if leashed then
			ply:send(("I am already with my %s%s %s"):format(config.mastername, (#with>1 and "s: " or " "), table.concat(with, ", ")))
		else
			piepan.me:moveTo(ply.channel)
			print(("[COMMAND] %s: summoned me to %s"):format(ply.name, ply.channel.name))
		end
	end
end, "Make the bot come to the channel you are in" )

command.Add( "fuckoff", function( ply, args )
	local leashed, with = amIWithAMaster()
	if not ply:isMaster() and leashed then
		ply:send(("I won't leave my %s%s %s"):format(config.mastername, (#with>1 and "s: " or " "), table.concat(with, ", ")))
	else
		piepan.me:moveTo(piepan.channels(config.home))
		print(("[COMMAND] %s: told me to fuck off"):format(ply.name))
	end
end, "Make the bot go to his channel" )

command.Add( "mute", function( ply, args )
	ply:mute(true)
end, "Mute yourself", true )

command.Add( "unmute", function( ply, args )
	ply:mute(false)
end, "Unmute yourself", true )

command.Add( "hash", function( ply, args )
	if not args[1] then
		ply:send(("%s: %s"):format(ply.name, ply.hash))
	else
		local target = piepan.users[args[1]]
		if target then
			ply:send(("%s: %s"):format(target.name, target.hash))
		else
			ply:send("User not found: " .. args[1])
		end
	end
end, "Get the hash of a user", true )

command.Add( "userid", function( ply, args )
	if not args[1] then
		ply:send(("%s: %s"):format(ply.name, ply.userId))
	else
		local target = piepan.users[args[1]]
		if target then
			ply:send(("%s: %s"):format(target.name, target.userId))
		else
			ply:send("User not found: " .. args[1])
		end
	end
end, "Get the user id of a user", true )

command.Add( "channel", function( ply, args )
	ply:send("Your current channel ID: " .. ply.channel.id)
end, "Get the channel ID of your current channel", true )