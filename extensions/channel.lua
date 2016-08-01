function mumble.channel:getUsers()
	local users = {}
	for session, user in pairs(dongerbot:getUsers()) do
		if self == user.channel then
			table.insert(users, user)
		end
	end
	return users
end

function mumble.client:getChannel(path)
    if self:getChannels()[0] == nil then
        return nil
    end
    return self:getChannels()[0](path)
end

function mumble.client:getUser(name)
    for session, user in pairs(self:getUsers()) do
        if user.name == name then
            return user
        end
    end
end

function mumble.channel:__call(path)
    assert(self ~= nil, "self cannot be nil")

    if path == nil then
        return self
    end

    local channel = self

    for k in path:gmatch("([^/]+)") do
        local current
        if k == "." then
            current = channel
        elseif k == ".." then
            current = channel.parent
        else
            current = channel.children[k]
        end

        if current == nil then
            return nil
        end
        channel = current
    end
    return channel
end