concommand.Add("status", function(cmd, args)
	print( "Mumble Server Status" )
	print( ("# %7s %6s %-10s"):format("session", "userid", "name") )
	for session, user in pairs(dongerbot:getUsers()) do
		print( ("# %7s %6s %-10s"):format(session, user.id or "unreg", user.name))
	end
end, "Display a list of all users")

local function printTree(branch, tabs)
	tabs = tabs or 0
	print(("%s%3i - %s (%i)"):format(("\t"):rep(tabs), branch.id, branch.name, #branch:getUsers()))
	for k,user in ipairs(branch:getUsers()) do
		print(("%s%3i - %s"):format(("\t"):rep(tabs + 1), user.id or 0, user.name))
	end

	for k,chan in ChannelPairs(branch.children, "id") do
		printTree(chan, tabs + 1)
	end
end

concommand.Add("channels", function(cmd, args)
	local root = dongerbot:getChannel(".")
	printTree(root)
end, "Display a list of all channels")