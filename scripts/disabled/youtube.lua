local https = require'ssl.https'
local json = require"dkjson"

local function getDuration(stamp)
	local hours = string.match(stamp, "(%d+)H") or 0
	local minutes = string.match(stamp, "(%d+)M") or 0
	local seconds = string.match(stamp, "(%d+)S") or 0

	if hours > 0 then
		return string.format("%02d:%02d:%02d", hours, minutes, seconds)
	else
		return string.format("%02d:%02d", minutes, seconds)
	end
end

local function youtube( channel, u )
	local req = https.request(("https://www.googleapis.com/youtube/v3/videos?key=%s&part=statistics,snippet,contentDetails&id=%s"):format(config.youtube.apiKey, id))
	if not req then print(err) return end
	if( #req == 0 ) then return end

	local js = json.decode( req )

	local items = js.items

	if not items then return "Private or Invalid YouTube video." end

	return ([[
<table>
	<tr>
		<td valign="middle">
			<img src='https://www.youtube.com/yt/brand/media/image/YouTube-icon-full_color.png' height="25" />
		</td>
		<td align="center" valign="middle">
			<a href="http://youtu.be/%s">%s (%s)</a>
		</td>
	</tr>
	<tr>
		<td></td>
		<td align="center">
			<a href="http://youtu.be/%s"><img src="%s" width="250" /></a>
		</td>
	</tr>
</table>
]]):format(u, items.snippet.title, getDuration(items.contentDetails.duration), u, items.snippet.thumbnails.medium.url)
end

hook.Add( 'OnMessage', 'YouTube Handler', function(event)
	local user = event.user
	local message = event.text

	if( message:find( "youtube%.com/watch.-v=([%w_-]+)" ) ) then
		user.channel:send(youtube( channel, message:match("youtube%.com/watch.-v=([%w_-]+)") ))
	elseif( message:find("youtu%.be/([%w_-]+)" ) ) then
		user.channel:send(youtube( channel, message:match("youtu%.be/([%w_-]+)" ) ))
	end
end)