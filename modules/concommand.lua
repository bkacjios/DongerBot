concommand = concommand or {
	Commands = {},
}

function concommand.Add(name, cb, help)
	concommand.Commands[name] = {
		name = name,
		callback = cb,
		help = help,
	}
end

function concommand.Alias(name, alias)
	local original = concommand.Commands[name]
	concommand.Commands[alias] = {
		name = alias,
		callback = original.callback,
		help = original.help,
		alias = true
	}
end

concommand.Add("help", function(cmd, args)
	print("Command List")
	for _,cmd in pairs(concommand.Commands) do
		print(("> %s"):format(cmd.name))
	end
end, "Display a list of all commands")
concommand.Alias("help", "commands")

function concommand.run(msg)
	msg = msg:gsub("\n", "")
	local args = string.parseArgs(msg)
	local cmdStr = table.remove(args,1)
	local cmd = concommand.Commands[cmdStr:lower()]
	if cmd then
		local suc, err = pcall(cmd.callback, cmdStr, args, msg)
		if not suc then
			log.error(("[CONSOLE] %s: %s (%q)"):format(msg, err))
		end
	else
		print(("Unknown command: %s"):format(cmdStr))
	end
	return false
end