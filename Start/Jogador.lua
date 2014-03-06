local StateMachine = require "StateMachine"

local Jogador = {}
function Jogador.new()

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
	
	novoJogador = display.newSprite(spriteSheet, sequenceData)	
	novoJogador.velocidade = 2	
	novoJogador.yInicial = nil	
	novoJogador.name = "jogador"
	novoJogador.health = 100
	novoJogador.attackPower = 10	
	novoJogador.fsm = StateMachine.new(novoJogador)	
	novoJogador.fsm:active()

	function novoJogador:inserir()
		self.x = 50; self.y = 50
	end

	function novoJogador:getName()
		return self.name
	end	
	
	
	return novoJogador
end		


return Jogador