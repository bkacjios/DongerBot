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

command.Add("about", function(ply, cmd, args)
	local message = [[<b>DongerBot</b>
Created by <a href="https://github.com/Someguynamedpie">Somepotato</a> &amp; <a href="https://github.com/bkacjios">Bkacjios</a><br/><br/>
<a href="https://github.com/bkacjios/DongerBot">https://github.com/bkacjios/DongerBot</a>
<a href="https://github.com/bkacjios/lua-mumble">https://github.com/bkacjios/lua-mumble</a>]]
	ply:message(message)
end, "Get some information about DongerBot")

command.Add("help", function(ply, cmd, args)
	local debug = args[1] == "user"
	local message = "Here's a list of commands<br/>"
	for _,cmd in pairs(command.Commands) do
		if not cmd.alias and ((cmd.senpai and (not debug and ply:isMaster())) or not cmd.senpai) then
			message = message .. "<b>!" .. cmd.name .. "</b>" .. (cmd.help and (" - <i>" .. cmd.help .. "</i>") or "") .. "<br/>"
		end
	end
	ply:message(message)
end, "Display a list of all commands")
command.Alias("help", "?")
command.Alias("help", "commands")

function command.poll(event)
	local user = event.actor
	local msg = event.message
	local marker = msg:sub(1,1)
	if marker == '!' or marker == '/' then
		msg = string.StripHTMLTags(msg)
		msg = string.unescape(msg)

		local args = string.parseArgs(msg)
		local cmdStr = table.remove(args,1)
		local cmd = command.Commands[ cmdStr:lower():sub(2) ]
		if cmd then
			if cmd.senpai and not user:isMaster() then
				log.warn(("[COMMAND] %s: %s (PERMISSION DENIED)"):format(user:getName(), msg))
				user:message("Permission denied: ".. cmdStr)
			else
				local suc, err = pcall(cmd.callback, user, cmdStr, args, msg)
				if not suc then
					log.error(("[COMMAND] %s: %s (%q)"):format(user:getName(), msg, err))
					user:message(("<b>%s</b> is currently <i>broken..</i>"):format(cmdStr))
				end
			end
		else
			log.info(("[COMMAND] %s: %s (Unknown Command)"):format(user:getName(), msg))
			user:message(("Unknown command: <b>%s</b>"):format(cmdStr))
		end
	end
end

dongerbot:hook("OnMessage", "command", command.poll)