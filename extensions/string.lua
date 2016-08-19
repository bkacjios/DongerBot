local char = string.char
local gsub = string.gsub

function string.trim(self, char)
	char = char or "%s"
	return (self:gsub("^"..char.."*(.-)"..char.."*$", "%1" ))
end

function string.AddCommas( str )
	return tostring(str):reverse():gsub("(...)", "%1,"):gsub(",$", ""):reverse()
end

local entityMap  = {
	["lt"]		= "<",
	["gt"]		= ">",
	["quot"]	= '"',
	["apos"]	= "'",
	["amp"]		= "&",
	["nbsp"]	= " ",
}

local function entitySwap(orig,n,s)
	return entityMap[s] or n=="#" and char(s) or n=="#x" and char(tonumber(s,16)) or orig
end

function string.unescape(str)
	return gsub(str, '(&(#?x?)([%d%a]+);)', entitySwap)
end

function string.StripHTMLTags(str)
	return gsub(str, "<.->", "")
end

function string.parseArgs(line)
	local cmd, val = line:match("(%S-)%s-=%s+(.+)")
	if cmd and val then
		return {cmd:trim(), val:trim()}
	end
	local quote = line:sub(1,1) ~= '"'
	local ret = {}
	for chunk in string.gmatch(line, '[^"]+') do
		quote = not quote
		if quote then
			table.insert(ret,chunk)
		else
			for chunk in string.gmatch(chunk, "%S+") do -- changed %w to %S to allow all characters except space
				table.insert(ret, chunk)
			end
		end
	end
	return ret
end

function string.Plural( str, num, suffix )
	local fmt = ("%i %s"):format(num, str)
	return num == 1 and fmt or (fmt .. (suffix or "s"))
end

function string.AOrAn( s )
	return string.match( s, "^h?[AaEeIiOoUu]" ) and "an" or "a"
end