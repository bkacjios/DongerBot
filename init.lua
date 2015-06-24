if not client then -- Allows this file to be auto-reloaded successfully
	client = _G.client
else
	_G.client = client
end

dofile("util.lua")
dofile("config.lua")
autoreload.watch("init.lua")
autoreload.watch("util.lua")
autoreload.watch("config.lua")

function client.onConnect()
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

function client.onDisconnect()
	hook.Run('OnDisconnect')
end

function client.onMessage(...)
	hook.Run('OnMessage', ...)
end

function client.onUserChange(...)
	hook.Run('OnUserChange', ...)
end

function client.onChannelChange(...)
	hook.Run('OnChannelChange', ...)
end

function client.onPermissionDenied(...)
	hook.Run('OnPermissionDenied', ...)
end

function client.onAudioFinished()
	hook.Run('OnAudioFinished')
end