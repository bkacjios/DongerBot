local lfs = require("lfs")

autoreload = autoreload or {
	monitoring = {},
	polling = false,	
}

function autoreload.start()
	if not autoreload.polling then
		autoreload.polling = true
		autoreload.poll()
	end
end

function autoreload.poll()
	for k,v in pairs(autoreload.monitoring) do
		local mod = lfs.attributes( k, 'modification' )
		if v ~= mod then
			autoreload.monitoring[ k ] = mod
			local succ, err = pcall(loadfile(k))
			if not succ then
				print( ("File reload (%s) FAILED: %q"):format(k, err) )
			else
				print( ("File reload (%s) SUCCESS"):format(k) )
			end
		end
	end
	piepan.Timer.new(autoreload.poll,1)
end

function autoreload.watch(f)
	autoreload.monitoring[ f ] = lfs.attributes(f, "modification")
end

function include(f)
	dofile(f)
	autoreload.watch(f)
end

function includeDir(directory)
	for file in lfs.dir(directory) do
		if file ~= '.' and file ~= '..' then
			local mode = lfs.attributes(directory .. file, "mode")
			if mode == 'file' then
				print(directory .. file)
				include(directory .. file)
			end
		end
	end
end