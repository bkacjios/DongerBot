tts = tts or {
	Directory = "ttsengines/",
	Engine = "dectalk",
	File = "tts.txt",
}

local function speakFileThread()
	print("Creating text-to-speach audio...")
	os.execute( 'wine ' .. tts.Directory .. tts.Engine .. '/' .. tts.Engine .. '.exe "' .. tts.Directory .. tts.File .. '" "' .. tts.Directory .. 'output.wav"' )
	print("Converting to vorbis...")
	os.execute( 'oggenc --quiet --resample 48000 ' .. tts.Directory .. 'output.wav -o ' .. tts.Directory .. 'tts.ogg' )
end

function tts.speak(txt)
	if piepan.Audio.isPlaying() then
		return
	end
	
    local f = assert(io.open(tts.Directory .. tts.File,'wb'))
    f:write('[:phone on][:error ignore on]' .. txt)
    f:close()

	piepan.Thread.new(speakFileThread, function()
    	piepan.Audio.stop()
		piepan.me.channel:play(tts.Directory .. "tts.ogg")
		print("TTS: " .. txt)
	end)
end

hook.Add( 'OnMessage', 'TTS Handler', function(event)
	local msg = event.text
	if msg:sub(1,1) == "$" then
		local message = msg:sub(2)
		message = string.StripHTMLTags(message)
		message = string.unescape(message)
		tts.speak(message)
	end
end )