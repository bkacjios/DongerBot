function mumble.user:isMaster()
	-- Allow the superuser or masters to control the bot
	return self.name == config.superuser or config.masters[self.hash]
end

function UserPairs(t)
	local s = {}
	for n,c in pairs(t) do
		table.insert(s, c)
	end
	table.sort(s, function(a,b)
		return (a.id or 0) < (b.id or 0)
	end)
	return pairs(s)
end