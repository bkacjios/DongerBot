local http  = require("socket.http")
http.TIMEOUT = 1
local https = require("ssl.https")
local json  = require("dkjson")

amer = amer or {
	in_game = false,
	last_abandon = nil,
	queue = {},
	accounts = {
		{
			account_id = 342189008,
			last_match = nil,
		},
		{
			account_id = 5224570,
			last_match = nil,
		}
	}
}

local quotes = {
	"The best apology is changed behavior.",
	"The best way out is always through.",
	"To be helpful is our only aim.",
	"Easy does it.",
	"Live and let live.",
	"One day at a time.",
	"Keep on trudgin.'",
	"Sobriety is a journey, not a destination.",
	"A.A. = Altered Attitudes",
	"Do it sober.",
	"You either are or you aren't.",
	"We're all here because we're not all there.",
	"It takes time.",
	"What goes around, comes around.",
	"To keep it, you have to give it away.",
	"This is a selfish program.",
	"If we don't grow, we gotta go.",
	"Slow but sure.",
	"One is too many, a thousand is not enough.",
	"We have a choice.",
	"It gets better.",
	"The door swings both ways.",
	"You have to put in the time.",
	"Your best thinking got you here.",
	"You can't speed up recovery, but you can slow it down."
}

function amer.checkGames(account)
	local raw, code = https.request(("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=%s&key=3E8739860EBA629CC6E322018EE45F6A"):format(account.account_id))

	if code ~= 200 then return end

	local data = json.decode(raw)

	-- Check for data
	if not data or not data.result or not data.result.matches then return end

	local matches = data.result.matches
	local last_game = matches[1].match_id

	-- Check if played a new game
	if last_game == account.last_match then return end

	account.last_match = last_game

	for k,match in pairs(matches) do
		if match.match_id ~= 2630939067 then
			-- Insert all matches that will need to be parsed into a stack
			table.insert(amer.queue, {
				match_id = match.match_id,
				account_id = account.account_id,
			})
		end
	end
end

function amer.checkAllAccountMatches()
	-- Check all of amers accounts..
	for k,account in pairs(amer.accounts) do
		amer.checkGames(account)
	end
end

concommand.Add("amer", function(cmd, args)
	local infraction = amer.last_abandon
	if infraction then
		local time = os.time()
		local date = infraction.time
		local time_match = math.SecondsToHuman(os.difftime(time, infraction.time))
		local time_left = math.SecondsToHuman(os.difftime(infraction.time + 604800, time))
		if not amer.last_abandon or amer.last_abandon.time + 604800 < time then
			time_left = "No time"
		end
		print("Amers last abandon")
		print(("MatchID: %s"):format(infraction.match_id))
		print(("Played : %s ago"):format(time_match))
		print(("Banned : %s left"):format(time_left))
	end
end, "Display amer debug information")

dongerbot:hook("OnUserChannel", "Amer - Stop being drunk", function(event)
	local user = event.user

	if user:getName() ~= "Amer" then return end

	local channel = dongerbot:getChannels()[30] or dongerbot:getChannels()[6]

	local hour = tonumber(os.date("%H"))
	
	if hour < 22 and hour > 9 then
		channel = dongerbot:getChannels()[31]
	end

	if not channel then return end

	local time = os.time()

	if amer.last_abandon and amer.last_abandon.time + 604800 >= time then
		user:move(channel)

		local infraction = amer.last_abandon
		local time_match = math.SecondsToHuman(os.difftime(time, infraction.time))
		local time_left = math.SecondsToHuman(os.difftime(infraction.time + 604800, time))

		user:message(([[Hello Amer.<br>
It has come to my attention you have abandoned a game of Dota %s ago.<br>
Because of this, you will be confined to this channel for %s, between the hours of 9AM and 9PM.
<br>
<b>Match ID:</b> <a href='http://www.dotabuff.com/matches/%s'>%s</a><br>
<br>
If you abandon another game, you will be held for <i>another</i> <b>week.</b><br>
<br>
Remeber, <i>“%s”</i>]]):format(time_match, time_left, infraction.match_id, infraction.match_id, quotes[math.random(1,#quotes)]))
	end
end)

local lastcheck

dongerbot:hook("OnTick", "Amer - Check Right Channel", function()
	local time = os.time()

	if lastcheck and lastcheck + 1 > time then return end
	lastcheck = time

	local amer = dongerbot:getUser("Amer")
	local hour = tonumber(os.date("%H"))

	if not amer then return end

	local channel = dongerbot:getChannels()[30] or dongerbot:getChannels()[6]
	local hisChannel = amer:getChannel()

	if not amer.in_game and hour < 22 and hour > 9 then
		channel = dongerbot:getChannels()[31]
	end

	if not channel or hisChannel == channel then return end

	if amer.last_abandon and amer.last_abandon.time + 604800 >= time then
		amer:move(channel)
	end
end)

dongerbot:hook("OnTick", "Amer - Check Match Details", function()
	local pop = table.remove(amer.queue, 1)
	if pop then
		local raw, code = https.request(("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=%s&key=3E8739860EBA629CC6E322018EE45F6A"):format(pop.match_id))
	
		if code ~= 200 then return end

		local data = json.decode(raw)

		if not data or not data.result or not data.result.players then return end

		local match = data.result
		local players = data.result.players

		for k, ply in pairs(players) do
			if ply.account_id == pop.account_id and ply.leaver_status >= 2 then
				pop.time = match.start_time + match.pre_game_duration + match.duration
				if not amer.last_abandon or amer.last_abandon.time < pop.time then
					log.warn(("[SOBRIETY] Amer abandoned a game: %s"):format(pop.match_id))
					amer.last_abandon = pop
				end
				amer.queue = {}
				break
			end
		end
	end
end)

local lastgamecheck

dongerbot:hook("OnTick", "Amer - Check in dota", function()
	local time = os.time()

	if not amer.last_abandon or amer.last_abandon.time + 604800 < time then return end

	if lastgamecheck and lastgamecheck + 10 > time then return end
	lastgamecheck = time

	local raw, code = https.request("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=3E8739860EBA629CC6E322018EE45F6A&steamids=76561198302454736,76561197965490298")

	if code ~= 200 then return end

	local data = json.decode(raw)

	if not data or not data.response or not data.response.players then return end

	local players = data.response.players

	for k,ply in pairs(players) do
		if ply.gameid == "570" then
			amer.in_game = true
			return
		end
	end

	amer.in_game = false
end)

dongerbot:hook("OnServerPing", "Amer - Check Games", function()
	amer.checkAllAccountMatches()
end)