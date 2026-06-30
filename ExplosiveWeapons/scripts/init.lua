local mod = {
	id = "TBC_Replace",
	name = "Funny Artillery",
	icon = "icon.png",
	description = "A goofy weapon for the Boom Bots which uses NClickLib",
	version = "1.0",
	modApiVersion = "2.8.3",
	gameVersion = "1.2.88",
	dependencies = {
		"Nico_Sent_weap",
	},
}

function mod:init()
	require(self.scriptPath .."libs/NClickLib")
	require(self.scriptPath .."artillery")
	--require(self.scriptPath .."laser")
end

function mod:load(options, version)
end

return mod