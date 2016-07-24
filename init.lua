dofile("util.lua")
dofile("config.lua")
autoreload.watch("init.lua")
autoreload.watch("util.lua")
autoreload.watch("config.lua")

function piepan.onConnect()
	if (piepan.me.userId and piepan.me.userId <= 0) or not piepan.me.userId then
		piepan.me:register() -- Attempt to register itself
	end

	include("hook.lua")
	include("command.lua")

	includeDir("extensions/")
	includeDir("scripts/")

	autoreload.start() -- Start checking for file changes

	hook.Run('OnConnect')
end

function piepan.onDisconnect()
	hook.Run('OnDisconnect')
end

function piepan.onMessage(message)
	hook.Run('OnMessage', message)
end

function piepan.onUserChange(event)
	hook.Run('OnUserChange', event)
	if event.isConnected then
		hook.Run('OnUserConnected', event)
	elseif event.isDisconnected then
		hook.Run('OnUserDisconnected', event)
	elseif event.isChangedChannel then
		hook.Run('OnUserChangedChannel', event)
	elseif event.isChangedComment then
		hook.Run('OnUserChangedComment', event)
	end
end

function piepan.onChannelChange(event)
	hook.Run('OnChannelChange', event)
end

function piepan.onPermissionDenied(event)
	hook.Run('OnPermissionDenied', event)
end

function piepan.onUserStats(...)
	hook.Run('OnUserStats', ...)
end

function piepan.onAudioFinished()
	hook.Run('OnAudioFinished')
end