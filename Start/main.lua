--[[
	Classe main criada como inicio do prototipo do jogotal.
	Este comentario de multiplas linhas e muito bacana!
--]]

system.activate( "multitouch" )
-- Carrega biblioteca de fisica usada pela engine
local physics = require ("physics")
physics.setGravity(0,9.8)
physics.start()
--[[
	Mostra o caminho onde o lua procura outros arquivos a serem adicionados
	print(package.path) 
--]]
-- Carrega classe gameSprite com a definicao de um Sprite
require ( "gameSprite" ) 
require ( "montarCenario")
require ( "Jogador" )
require ( "GameLoop" )

function iniciaJogo()
	jogador = Jogador:new()
	jogador:inserir()
	physics.addBody(jogador.sprite, {density= 3.0, friction=0.5, bounce=0.3})
end
iniciaJogo()





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

local personagem = GameSprite:new()
personagem.vida = 100
personagem:setSpriteSheet("zero2.png", options)
personagem:createSprite(sequenceData)
personagem.sprite.x = 200;personagem.sprite.y = 50
personagem.sprite:setSequence("correndo")
personagem:setEstado(EstadoParado:new())
personagem:acao()

physics.addBody(personagem.sprite, {density= 3.0, friction=0.5, bounce=0.3})


-- implementa o evento acionado quando existir colisao
local colisaoChao = function (self, event)
	if ( event.phase == "began" ) then	
			personagem.sprite:setSequence("correndo")
			personagem.estadoSprite = EstadoParado:new()
			personagem:acao()
	elseif ( event.phase == "ended" ) then
			
	end
end

-- registra o evento de colisao
personagem:adicionarColisao("collision", colisaoChao)

--[[
	Codigo que implementa o evento de movimentacao e pulo do personagem.
--]]
local holding = false
local isRight = false

-- Este evento e acionado a cada frame desenhado (30 ou 60 fps)
local function enterFrameListener(event)	
	if holding then
		local movimento = personagem:mover(personagem.sprite.x, personagem.sprite.y, isRight)
		personagem.sprite:play()
		personagem.sprite.x = personagem.sprite.x + movimento
	end
end

-- Metodo que trata o evento de toque na tela
local function touchHandler( event )
    if event.phase == "began" then
        Runtime:addEventListener( "enterFrame", enterFrameListener )
        holding = true
    elseif event.phase == "ended" then
		personagem.estadoSprite = EstadoParado:new()
		personagem:acao()

		holding = false
		Runtime:removeEventListener( "enterFrame", enterFrameListener )
    end	
	isRight = (event.x > personagem.sprite.x + personagem.sprite.width)
    return true
end

local isJumping = false

-- Metodo que trata o evento de pulo do personagem principal
local function onScreenTap( event )
	if event.numTaps >= 2 then
		personagem.estadoSprite = EstadoPulando:new()
		personagem:acao()
		isJumping = true
	end	
end

-- Adiciona os eventos a tela principal (pulo e toque)
Runtime:addEventListener( "tap", onScreenTap )
Runtime:addEventListener("touch", touchHandler)



