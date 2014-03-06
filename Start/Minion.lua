local MinionStateMachine = require "MinionStateMachine"

local Minion = {}
function Minion.new(groupEnemy)		
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
	local spriteSheet =  graphics.newImageSheet("zero2.png", options)
	local newEnemy = display.newSprite(spriteSheet, sequenceData)
	
	newEnemy.name = "enemy"
	newEnemy.velocidade = 2
	newEnemy.estadoSprite = nil
	newEnemy.yInicial = nil
	newEnemy.sheet = spriteSheet	
	newEnemy.health = 30	
	newEnemy.fsm = MinionStateMachine.new(newEnemy)

	return newEnemy
end
return Minion