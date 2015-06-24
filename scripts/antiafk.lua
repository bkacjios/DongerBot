local function aafkTimer()
	piepan.Timer.new(aafkTimer, 1800)
	piepan.me:send("AntiAFK")
end
piepan.Timer.new(aafkTimer, 1800)