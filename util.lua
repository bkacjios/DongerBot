local lfs = require("lfs")

autoreload = autoreload or {
	monitoring = {},	
}

function autoreload.poll()
	for k,v in pairs(autoreload.monitoring) do
		local mod = lfs.attributes( k, 'modification' )
		if v ~= mod then
			autoreload.monitoring[ k ] = mod
			local succ, err = pcall(dofile, k)
			if not succ then
				log.info(("[AUTORELOAD] %s"):format(err))
			else
				log.info(("[AUTORELOAD] %s"):format(k))
			end
		end
	end
end

dongerbot:hook("onTick", autoreload.poll)

function autoreload.watch(f)
	autoreload.monitoring[ f ] = lfs.attributes(f, "modification")
end

function include(f)
	autoreload.watch(f)
	local succ, err = pcall(dofile, f)
	if not succ then
		log.info(("[INITIALIZE] %s"):format(err))
	else
		log.info(("[INITIALIZE] %s"):format(f))
	end
end

function includeDir(directory)
	for file in lfs.dir(directory) do
		if file ~= '.' and file ~= '..' then
			local path = directory .. file
			local mode = lfs.attributes(path, "mode")
			if mode == 'file' then
				include(path)
			end
		end
	end
end