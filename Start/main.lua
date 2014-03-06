--[[
	Classe main criada como inicio do prototipo do jogotal.
	Este comentario de multiplas linhas e muito bacana!
--]]

system.activate( "multitouch" )
-- Carrega biblioteca de fisica usada pela engine
local physics = require ("physics")
physics.start()
physics.setGravity(0, 0)
--[[
	Mostra o caminho onde o lua procura outros arquivos a serem adicionados
	print(package.path) 
--]]
-- Carrega classe gameSprite com a definicao de um Sprite
--require ( "montarCenario")
local Jogador = require ( "Jogador" )
local Minion = require ( "Minion" )
require ( "EnemyManager" )
 

_H = display.contentHeight
_W = display.contentWidth

local setaDireita = {}
local setaEsquerda = {}
function preparaCenario()
	fundo = display.newImage("fundo.png")
	fundo.x = 285; fundo.y = 160
	
	chao = display.newImage("ground.png")
	chao.x = 0; chao.y = _H-chao.height/2

	setaEsquerda = display.newImage("setaesquerda.png")
	setaEsquerda.name = "esquerda"
	setaEsquerda.y = _H-setaEsquerda.height
	setaEsquerda.x = setaEsquerda.width
	
	setaDireita = display.newImage("setadireita.png")
	setaDireita.name = "direita"
	setaDireita.y = setaEsquerda.y
	setaDireita.x = setaEsquerda.x + setaEsquerda.width*2
	

	local pontoFocal = display.newImage("arvore2.png")
	pontoFocal.name = "pontoFocal"
	physics.addBody(pontoFocal, {density = 3.0, friction=3.0, bounce=0})
	pontoFocal.isSensor = true
	pontoFocal.x = _W/2; pontoFocal.y = chao.y-chao.height
end
preparaCenario()

jogador = Jogador.new()
jogador:inserir()	
jogador.y = _H-chao.height
jogador.yInicial = jogador.y
physics.addBody(jogador, {density=3.0, friction=3.0, bounce=0})
jogador.isSensor = true

local enemyManager = EnemyManager:new(15)

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
	local minion = Minion.new()	
	physics.addBody(minion, {density= 3.0, friction=3.0, bounce=0.0, filter = {maskBits = 1, categoryBits = 2} })	
	minion.isSensor = true
	minion.y = jogador.y
	

	local isRight = true	
	if math.random(15) > 7 then		
		isRight = false	
		minion.x = display.contentWidth+10		
	else		
		minion.x = -10
	end
	minion.fsm.isRight = isRight	
	enemyManager:addEnemy(minion)
	minion.fsm:move(event)
end


jogador.fsm.isHolding = false
local function move(event)
	local isMovingOnTheGround = jogador.y > jogador.yInicial-1	
	local isRight = true
	
	if (event.target.name == "esquerda") then
		isRight = false
	end	
    if event.phase == "began" or event.phase == "moved" then		
        display.getCurrentStage():setFocus(event.target)
        event.target.isFocus=true
		if inBounds(event) then			
			jogador.fsm.isHolding = true
			event.target.isFocus = true				
			if (jogador.fsm.currentState.name ~= "MovendoState") then
				if isMovingOnTheGround then					
					jogador.fsm:move(event, isRight)
				else			
					jogador.fsm:movingJump(event, isRight)
				end				
			end				
		else
			display.getCurrentStage():setFocus(nil)
			jogador.fsm:active(event)
			event.target.isFocus = false			
		end
	
    elseif (event.phase == "ended")  then
		jogador.fsm.isHolding = false		
		if isMovingOnTheGround then
			jogador.fsm:active(event)
		end
		
		display.getCurrentStage():setFocus(nil)
        event.target.isFocus = false
		
    end	
    return true


end
setaDireita:addEventListener("touch", move)
setaEsquerda:addEventListener("touch", move)



function inBounds( event )
    local bounds = event.target.contentBounds
    if event.x > bounds.xMin and event.x < bounds.xMax and event.y > bounds.yMin and event.y  < bounds.yMax then
        return true
    end
    return false
end 

-- Metodo que trata o evento de pulo do personagem principal
local function onScreenTap( event )
	if event.numTaps >= 2 then	
		jogador.fsm:jump()		
	end	
end

-- Evento entre os frames
Runtime:addEventListener( "enterFrame", enterFrameListener )
-- Adiciona os eventos a tela principal (pulo e toque)
Runtime:addEventListener( "tap", onScreenTap )
