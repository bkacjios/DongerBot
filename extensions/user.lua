function piepan.User:isMaster()
	-- Allow the superuser or masters to control the bot
	return self.name == config.superuser or config.masters[self.hash]
end