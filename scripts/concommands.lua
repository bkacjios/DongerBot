local function longestName(users)
	local longest
	for k,user in pairs(users) do
		local name = user:getName()
		if not longest or #longest < #name then
			longest = name
		end
	end
	return longest
end

concommand.Add("status", function(cmd, args)
	print("Mumble Server Status")

	local users = dongerbot:getUsers()

	local longest = longestName(users)

	print(("# %2s %7s %-".. #longest .."s %-8s %-8s"):format("id", "session", "name", "channel", "comment"))
	for k, user in UserPairs(users) do
		print(("# %2s %7s %-".. #longest .."s %-8s %-8s"):format(user:getID(), user:getSession(), user:getName(), user:getChannel():getID(), user:getComment()))
	end
end, "Display a list of all users")

local function printTree(branch, tabs)
	tabs = tabs or 0
	print(("%s%3i - %s (%i)"):format(("\t"):rep(tabs), branch:getID(), branch:getName(), #branch:getUsers()))
	for k,user in ipairs(branch:getUsers()) do
		print(("%s%3i - %s"):format(("\t"):rep(tabs + 1), user:getID(), user:getName()))
	end

	for k,chan in ChannelPairs(branch:getChildren()) do
		printTree(chan, tabs + 1)
	end
end

concommand.Add("channels", function(cmd, args)
	local root = dongerbot:getChannel(".")
	printTree(root)
end, "Display a list of all channels")

concommand.Add("disconnect", function(cmd, args)
	dongerbot:disconnect()
end)

for k,v in pairs(dongerbot:getUsers()) do
	print(v:getName(), v:getCommentHash())
end