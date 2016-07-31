youtube = {
    Directory = "youtube/",
    Queue = {},
    Playing = false,
    Votes = {},
}
function youtube.checkQueue()
    local top = youtube.Queue[1]
    if top and not piepan.Audio.isPlaying() then
        youtube.Playing = top
        piepan.me.channel:play(top)
        print(("Playing YouTube audio: %q"):format(top))
        table.remove(youtube.Queue, 1)
    end
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function youtube.addToQueue(user, id)
    piepan.Thread.new(function()
        if file_exists(youtube.Directory .. id ..'.ogg') then return end
        print("Downloading YouTube video...")
        user:send("Downloading YouTube video...")
        os.execute(("youtube-dl %q --quiet --extract-audio --audio-format wav -o '" .. youtube.Directory .. "%%(id)s.%%(ext)s'"):format(id))
        print("Converting YouTube video to audio only...")
        user:send("Converting YouTube video to audio only...")
        os.execute('oggenc --quiet --resample 48000 --downmix "' .. youtube.Directory .. id ..'.wav" && rm "' .. youtube.Directory .. id ..'.wav"')
    end, function()
        table.insert(youtube.Queue, youtube.Directory .. id .. ".ogg")
        print(("%s added YouTube video %q to queue"):format(user.name, id))
        user:send("Successfully added YouTube video to queue!")
        youtube.checkQueue()
    end)
end

command.Add( "voteskip", function( ply, args )
    if not ply.userId then
        ply:send("You must be registered in order to use this command!")
        return
    end
    if not youtube.Playing then
        ply:send("There is nothing to voteskip!")
        return
    end
    if not youtube.Votes[ply.userId] then
        youtube.Votes[ply.userId] = true

        local votes = table.Count(youtube.Votes)
        local need = math.ceil(config.youtube.percentToSkip * (#piepan.me.channel:getUsers()-1)) - votes

        if need > 0 then
            ply.channel:send(("%s voted to skip the current track (need %i more)"):format(ply.name, need))
        else
            ply.channel:send(("%s voted to skip the current track (stopping track)"):format(ply.name))
            piepan.Audio.stop()
        end
    else
        ply:send("You already voted to skip the current track!")
    end
end, "Vote to skip the current youtube video" )

command.Add("queue", function(user, args)
    local link = args[1]

    if user.channel.id ~= piepan.me.channel.id then
        user:send("You must be in the same channel as the bot to use this command.")
        return
    end
    
    if config.youtube.banned[user.hash] then
        user:send("Congrats, you lost YouTube privileges.")
        print(("Retard %s tried to play a youtube video"):format(user.name))
        return
    end

    local id

    if( link:find( "youtube%.com/watch.-v=([%w_-]+)" ) ) then
        id = link:match("youtube%.com/watch.-v=([%w_-]+)")
    elseif( link:find("youtu%.be/([%w_-]+)" ) ) then
        id = link:match("youtu%.be/([%w_-]+)")
    end

    if id then
        youtube.addToQueue(user, id)
    end
end, "Queue up a YouTube video to have its audio played")

hook.Add("OnAudioFinished", "YouTube CheckQueue", function()
    if youtube.Playing then
        --os.remove(youtube.Playing)
        youtube.Playing = false
    end
    youtube.Votes = {}
    youtube.checkQueue()
end)