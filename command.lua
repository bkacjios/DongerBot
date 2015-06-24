command = command or {
	Commands = {},
}

function command.Add(name, cb, help, senpai)
	command.Commands[name] = {
		name = name,
		callback = cb,
		help = help,
		senpai = senpai
	}
end

function command.Alias(name, alias)
	local original = command.Commands[name]
	command.Commands[alias] = {
		name = alias,
		callback = original.callback,
		help = original.help,
		senpai = original.senpai,
		alias = true
	}
end

command.Add("about", function(ply, args)
	local message = [[<b>DongerBot</b>
Created by <a href="https://github.com/Someguynamedpie">Somepotato</a> &amp; <a href="https://github.com/blackawps">Bkacjios</a><br/><br/>
<a href="https://github.com/blackawps/DongerBot">https://github.com/blackawps/DongerBot</a>
<a href="https://github.com/Someguynamedpie/piepan">https://github.com/Someguynamedpie/piepan</a>]]
	ply:send(message)
end, "Get some information about DongerBot")

command.Add("help", function(ply, args)
	local debug = args[1] == "user"
	local message = "Here's a list of commands<br/>"
	for _,cmd in pairs(command.Commands) do
		if not cmd.alias and ((cmd.senpai and (not debug and ply:isMaster())) or not cmd.senpai) then
			message = message .. "<b>!" .. cmd.name .. "</b>" .. (cmd.help and (" - <i>" .. cmd.help .. "</i>") or "") .. "<br/>"
		end
	end
	ply:send(message)
end, "Display a list of all commands")
command.Alias("help", "?")
command.Alias("help", "commands")

local function parseArgs(line)
	local cmd, val = line:match("(%S-)%s-=%s+(.+)")
	if cmd and val then
		return {cmd:trim(), val:trim()}
	end
	local quote = line:sub(1,1) ~= '"'
	local ret = {}
	for chunk in string.gmatch(line, '[^"]+') do
		quote = not quote
		if quote then
			table.insert(ret,chunk)
		else
			for chunk in string.gmatch(chunk, "%S+") do -- changed %w to %S to allow all characters except space
				table.insert(ret, chunk)
			end
		end
	end
	return ret
end

hook.Add( 'OnMessage', 'Command Handler', function(event)
	local user = event.user
	local msg = event.text
	local marker = msg:sub(1,1)
	if marker == '!' or marker == '/' then
		local raw = msg:sub(2)
		raw = string.StripHTMLTags(raw)
		raw = string.unescape(raw)

		local args = parseArgs(raw)
		local cmdStr = table.remove(args,1):lower()
		local cmd = command.Commands[ cmdStr ]
		if cmd then
			if cmd.senpai and not user:isMaster() then
				user:send("Permission Denied: ".. cmd)
			else
				local suc, err = pcall(cmd.callback, user, args, raw)
				if not suc then
					print(("Command (%q) by %s FAILED: %q"):format(raw, user.name, err))
				end
			end
		else
			user:send("Command not found: "..cmdStr)
		end
		return false
	end
end )