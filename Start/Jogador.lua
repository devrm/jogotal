require "com.jessewarden.statemachine.StateMachine"
require "estados.AtivoState"
require "estados.MovendoState"
require "estados.CorrendoDireitaState"
require "estados.AtacandoState"

Jogador = {}

function Jogador:new()

	local jogador = display.newGroup()	

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
	local sprite = display.newSprite(spriteSheet, sequenceData)
	
	jogador.velocidade = 3
	jogador.estadoSprite = nil
	jogador.sheet = spriteSheet
	jogador.sprite = sprite
	
	
	local fsm = StateMachine:new(jogador)
	jogador.fsm = fsm
	fsm:addState2(AtivoState:new())	
	fsm:addState2(CorrendoDireitaState:new())
	fsm:addState2(AtacandoState:new())	
	
	function jogador:inserir()
		jogador.sprite.x = 50; jogador.sprite.y = 50
		jogador.sprite:setSequence("parado")
		jogador.sprite:play()
	end
	
	
	
	return jogador
end
return Jogador