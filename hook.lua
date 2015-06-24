--uHook by Somepotato
hook = {}

local hooks = {}

function hook.Add( k, n, cb )
	hooks[k]=hooks[k]or{}
	hooks[k][n]=cb
end

function hook.Remove(k,n)
	if hooks[k]then hooks[k][n]=nil end
end

function hook.Run( K, ... )
	if not hooks[K]then return end
	local ret
	for k,v in pairs(hooks[K]) do
		ret={pcall(v,...)}
		if not ret[1] then
			print(("HOOK ERROR:%s.%s:%s"):format(K,k,ret[2]))
		elseif #ret > 1 then
			table.remove(ret,1)
			return unpack(ret)
		end
	end
end

function hooks.GetAll()
	return hooks
end