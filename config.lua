--[[
	All user specific settings use the hash of a users
	authentication certificate to prevent spoofing.

	- Use the command !hash to find a users hash via the SuperUser.
	- Disable SuperUser access by setting it to nil or false.
]]

config = {
	-- A username that can initialy control the bot.
	-- Set to false or nil after setting up the masters list as it is unsecure.
	-- This is perfectly fine to leave as-is if you own the server
	-- in which the bot will reside in. This will just mean that
	-- the mumble-server's "SuperUser" will also have control over the bot.
	superuser = "SuperUser",

	-- What the bot will call its masters
	mastername = "senpai",

	-- Users who have advanced command access
	masters = {
		["b304c9259eca9d38abb8cebd242b4609be2f972e"] = true,	-- Bkacjios
		["14375fa14fb1c2f7d2b6a1a40302613fc2211d5a"] = true,	-- Somepotato
	},

	-- The default channel for the bot
	home = "Private Channels/The lair of the DONGER",

	youtube = {
		-- A youtube api key
		apiKey = "",

		-- Percentage of users who want to vote-skip
		percentToSkip = 0.5, -- 50% majority vote

		-- Users who should be prevented from adding youtube audio tracks
		banned = {
		    ["ace706de79dba0218df641ff44499ea5bd0331ad"] = true,
		    ["0e6c40ace9f615de8cc9078c9faa1c344f4065bb"] = true,
		    ["702c2067c4fff9b209f8ab3020712312ce1753fb"] = true,
		}
	}
}