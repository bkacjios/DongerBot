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