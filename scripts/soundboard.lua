soundboard = {
	directory = "soundboard/",
	sounds = {},
}

function soundboard.reload()
	for file in lfs.dir(soundboard.directory) do
		if file ~= '.' and file ~= '..' then
			local attr = lfs.attributes(soundboard.directory..file,'mode')
			if attr == 'file' then
				soundboard.sounds[ file:gsub('%.ogg','') ] = file
			elseif attr=='directory' then
				soundboard.sounds[ file ] = {}
				for f2 in lfs.dir(soundboard.directory..file) do
					if f2 ~= '.' and f2 ~= '..' then
						table.insert(soundboard.sounds[ file ],f2)
					end
				end
			end
		end
	end
	log.debug("[SOUNDBOARD] Loaded audio files..")
end
soundboard.reload()

function soundboard.issound(name)
	return soundboard.sounds[name] ~= nil
end

function soundboard.playsound(name, override)
	local sound = soundboard.sounds[name]
	if type(sound) == 'table' then
		sound = name .. '/' .. soundboard.sounds[name][math.random(1,#soundboard.sounds[name])]
	end
	if sound and (not dongerbot:isPlaying() or override) then
		dongerbot:play(soundboard.directory..sound)
		return true
	end
end

command.Add( "sounds", function( ply, args )
	local messages = { "<b>Sounds</b><br/>" }
	local i = 0
	for k,v in pairs(soundboard.sounds) do
		local x = math.ceil(i/50)
		if not messages[x] then messages[x] = "" end
		messages[x] = messages[x] .. "<i>#" .. k .. "</i><br/>"
		i = i + 1
	end
	for k,message in pairs(messages) do
		ply:message(message)
	end
end, "List all the sounds available on the soundboard" )

--[[local target = mumble.voicetarget()
target:setChannel(dongerbot:getChannel("."))
target:setChildren(true)
target:setLinks(true)
dongerbot:registerVoiceTarget(1, target)

local target = mumble.voicetarget()
target:addUser(dongerbot:getUser("Bkacjios"))
dongerbot:registerVoiceTarget(2, target)

dongerbot:setVoiceTarget(1)
dongerbot:play("soundboard/yes.ogg")]]

dongerbot:hook("OnMessage", "Soundboard Handler", function(event)
	local actor = event.actor

	local msg = event.message
	if msg:sub(1,1) == "#" then
		local name = msg:sub(2):lower()
		if name == "reload" then
			soundboard.reload()
			log.debug(("[SOUNDBOARD] %s: reloaded all sounds"):format(actor:getName()))
		elseif soundboard.issound(name) then

			local target = mumble.voicetarget()
			target:setChannel(actor:getChannel())
			dongerbot:registerVoiceTarget(1, target)

			dongerbot:setVoiceTarget(1)
			soundboard.playsound(name, true)
			log.debug(("[SOUNDBOARD] %s: #%s"):format(actor:getName(), name))
		end
	end
end )