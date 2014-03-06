local Qualquer = {}
local Qualquer_mt = { __index = Qualquer}

function Qualquer.new()

	local options = {
		width = 45,
		height = 45,
		numFrames = 14
	}

	local sequenceData = {
		{ name = "parado", start=1, count=1, time=0,   loopCount=1 },
		{ name = "correndo", start=1, count=11, time=500},
		{ name = "pulando", start=11, count=3,  time=900}
	}
	local spriteSheet = graphics.newImageSheet("zero2.png", options)
	
	local novoQualquer = display.newSprite(spriteSheet, sequenceData)	

	return novoQualquer
end		

function Qualquer:inserir()
	self.x = 50; self.y = 50
end

function Qualquer:getName()
	return self.name
end
return Qualquer