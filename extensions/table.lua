function table.Count(table)
    local i = 0
    for k,v in pairs(table) do
        i = i + 1
    end
    return i
end

function table.Random(table)
	return table[math.random(1,#table)]
end