--[[
	Classe main criada como inicio do prototipo do jogotal.
	Este comentario de multiplas linhas e muito bacana!
--]]

--system.activate( "multitouch" )
-- Carrega biblioteca de fisica usada pela engine
local physics = require ("physics")
physics.start()
--[[
	Mostra o caminho onde o lua procura outros arquivos a serem adicionados
	print(package.path) 
--]]
-- Carrega classe gameSprite com a definicao de um Sprite
--require ( "montarCenario")
require ( "Jogador" )
require ( "Minion" )
require ( "EnemyManager" )
 
local groupBackground = display.newGroup()
local groupForeground = display.newGroup()
local groupScenario   = display.newGroup()
local groupEnemies    = display.newGroup()
local groupPlayer	  = display.newGroup()


_H = display.contentHeight
_W = display.contentWidth


function preparaCenario()
	fundo = display.newImage("fundo.png")
	fundo.x = 285; fundo.y = 160
	groupBackground:insert(fundo)
	
	chao = display.newImage("ground.png")
	chao.x = 0; chao.y = _H-chao.height/2
	groupForeground:insert(chao)

	local chaoFisico = display.newRect(0,_H-chao.height/2,_W,1)
	chaoFisico.name = "chaoFisico"
	chaoFisico.alpha = 0
	physics.addBody(chaoFisico, "static", {friction=3.0, bounce=0, filter = {maskBits = 3, categoryBits = 1}})	
	
	local pontoFocal = display.newImage("arvore2.png")
	pontoFocal.name = "pontoFocal"
	groupScenario:insert(pontoFocal)
	physics.addBody(pontoFocal, "static", {density = 3.0, friction=3.0, bounce=0, filter = {maskBits = 2, categoryBits = 3}})	
	pontoFocal.x = _W/2; pontoFocal.y = chao.y-chao.height
end

function iniciaJogo()

	enemyManager = EnemyManager:new(15)
	
	jogador = Jogador:new(groupPlayer)
	jogador:inserir()	
	jogador.sprite.y = _H-chao.height
	physics.addBody(jogador.sprite, {density=3.0, friction=3.0, bounce=0})	
end
preparaCenario()
iniciaJogo()

local runtime = 0
local function  getDeltaTime()
	local temp = system.getTimer()
	local dt = (temp-runtime)/(1000/30)
	runtime = temp
	return dt
end



counter = 120
-- Este evento e acionado a cada frame desenhado (30 ou 60 fps)
local function enterFrameListener(event)

	-- DELTA TIME
	dt = getDeltaTime()	
	
	jogador.fsm:update(dt)
	
	if counter == counter/2 then
		insertEnemy()		
		counter = 120
	end	
	counter = counter-1	
	enemyManager:action(dt)
end


function insertEnemy()	
	local minion = Minion:new(groupEnemies)	
	physics.addBody(minion.sprite, {density= 3.0, friction=3.0, bounce=0.0, filter = {maskBits = 1, categoryBits = 2} })
	minion.sprite.y = _H-chao.height
	local isRight = true	
	if math.random(15) > 7 then		
		isRight = false	
		minion.sprite.x = display.contentWidth+10		
	else		
		minion.sprite.x = -10
	end
	minion.fsm.isRight = isRight	
	enemyManager:addEnemy(minion)
	minion.fsm:move(event)
end


local isHolding = false

-- Metodo que trata o evento de toque na tela
local function touchHandler( event )	
	local isMovingOnTheGround = jogador.sprite.y > jogador.yInicial-1
	
	local isRight = (event.x > jogador.sprite.x + jogador.sprite.width)
	isHolding = true
    if event.phase == "began" or event.phase == "moved" then
		if isMovingOnTheGround then			
			jogador.fsm:move(event, isRight)
		else			
			jogador.fsm:movingJump(event, isRight)
		end		
    elseif event.phase == "ended" then
		isHolding = false		
		if isMovingOnTheGround then
			jogador.fsm:active(event)
		end
    end	
    return true
end
Runtime:addEventListener( "enterFrame", enterFrameListener )


-- implementa o evento acionado quando existir colisao
local colisaoChao = function (self, event)
	local isRight = true	
	if jogador.sprite.xScale < 1 then
		isRight = false
	end
	
	if ( event.phase == "began" ) then
		if event.other.name == "enemy" then			
			jogador.fsm:attack()			
			if event.other.xScale == -1 then
				event.other.sprite.x = event.other.x+event.other.width/2
			else
				event.other.x = event.other.x-event.other.width/2
			end		
		elseif event.other.name == "chaoFisico" then		
			if isHolding then			
				jogador.fsm:move(event, isRight)
			else
				jogador.fsm:active()			
			end
			jogador.yInicial = jogador.sprite.y
		end	
	elseif ( event.phase == "ended" ) then
		
	end
end
-- registra o evento de colisao
jogador.sprite:addEventListener("collision", jogador.sprite)
jogador.sprite.collision = colisaoChao

-- Metodo que trata o evento de pulo do personagem principal
local function onScreenTap( event )
	if event.numTaps >= 2 then		
		jogador.fsm:jump()		
	end	
end

-- Adiciona os eventos a tela principal (pulo e toque)
Runtime:addEventListener( "tap", onScreenTap )
Runtime:addEventListener("touch", touchHandler)