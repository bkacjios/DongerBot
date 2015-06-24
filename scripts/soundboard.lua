local directory = "soundboard/"
local sounds = {}

local function reload()
	for file in lfs.dir(directory) do
		if file ~= '.' and file ~= '..' then
			local attr = lfs.attributes(directory..file,'mode')
			if attr == 'file' then
				sounds[ file:gsub('%.ogg','') ] = file
			elseif attr=='directory' then
				sounds[ file ] = {}
				for f2 in lfs.dir(directory..file) do
					if f2 ~= '.' and f2 ~= '..' then
						table.insert(sounds[ file ],f2)
					end
				end
			end
		end
	end
	print("Soundboard: Loaded audio files..")
end
reload()

hook.Add( 'OnMessage', 'Soundboard Handler', function(event)
	local msg = event.text
	if msg:sub(1,1) == "#" then
		local name = msg:sub(2):lower()
		if name == "reload" then
			reload()
		else
			local sound = sounds[name]
			if type(sound) == 'table' then
				sound = name .. '/' .. sounds[name][math.random(1,#sounds[name])]
			end
			if sound and not piepan.Audio.isPlaying() then
				piepan.Audio.stop()
				piepan.me.channel:play(directory..sound)
				print(("Soundboard: #%s"):format(name))
			end
		end
	end
end )