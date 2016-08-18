function table.Count(t)
	local i = 0
	for k,v in pairs(t) do
		i = i + 1
	end
	return i
end

function table.Random(t)
	return t[math.random(1,#t)]
end

function table.Shuffle(t)
	local n = #t
	while n > 2 do
		-- n is now the last pertinent index
		local k = math.random(1, n) -- 1 <= k <= n
		-- Quick swap
		t[n], t[k] = t[k], t[n]
		n = n - 1
	end
end

function table.ShuffleInto(t)
	local r = {}
	while #t > 0 do
		table.insert(r, table.remove(t, math.random(#t)))
	end
	return r
end

function table.ShuffleCopy(t)
	local r = {}

	local keys = {}

	for key in pairs(t) do
		table.insert(keys, key)
	end

	while #keys > 0 do
		table.insert(r, t[table.remove(keys, math.random(#keys))])
	end
	return r
end