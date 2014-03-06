local EstadoAtivo = require "estados.EstadoAtivo"
require "estados.AtivoState"
require "estados.MovendoState"
require "estados.EstadoPulando"
require "estados.PulandoParabolaState"
require "estados.EstadoAtaque"

local MinionStateMachine = {}

function MinionStateMachine.new(minion)
	local minionStateMachine = {}
	minionStateMachine.currentState = EstadoAtivo.new(minion)
	minionStateMachine.previousState = nil
	minionStateMachine.globalState = nil
	minionStateMachine.owner = minion
	minionStateMachine.deltaTime = nil
	
	function minionStateMachine:setOwner(owner)
		self.owner = owner		
	end	
	
	function minionStateMachine:changeState(state)
		
		self.previousState = self.currentState
		
		self.currentState:onExitState()
		
		self.currentState  = state		
		
		self.currentState:onEnterState()
		
	end
	
	function minionStateMachine:changeToPreviousState()
		self:changeState(self.previousState)
	end
	
	function minionStateMachine:getCurrentState()
		return self.currentState
	end
	
	function minionStateMachine:move(event)		
		self.owner:setSequence("correndo")
		self.owner:play()	
		local moveState = MovendoState:new(self.owner, self.isRight)
		self:changeState(moveState)
	end
	
	function minionStateMachine:jump()
		local jumpState = EstadoPulando:new(self.owner)		
		self:changeState(jumpState)
	end	
	
	function minionStateMachine:active(event)		
		self.owner:setSequence("parado")
		self.owner:play()
		local activeState = EstadoAtivo:new(self.owner)
		self:changeState(activeState)
	end
	
	function minionStateMachine:update(deltaTime)		
		if (self.globalState) then
			self.globalState:executeAction(event, deltaTime)
		end
		
		if (self.currentState) then
			self.currentState:executeAction(event, deltaTime)
		end
	end
	
	function minionStateMachine:movingJump(event, isRight)		
		local jump = PulandoParabolaState:new(self.owner, isRight)
		self:changeState(jump)
	end	
	
	function minionStateMachine:ataque()
		local estadoAtaque = EstadoAtaque:new(self.owner)
		
		self:changeState(estadoAtaque)
	end
		
		
	-- implementa o evento acionado quando existir colisao
	local colisao = function (self, event)
		if ( event.phase == "began" ) then
			if event.other.name == "chaoFisico" then
				minionStateMachine:move()
			elseif event.other.name == "jogador" or event.other.name == "pontoFocal" then		
				print("ATAQUE")
				minionStateMachine:ataque()
			end	
		elseif ( event.phase == "ended" ) then
			minionStateMachine:move()			
		end
	end

	-- registra o evento de colisao
	minionStateMachine.owner:addEventListener("collision", minionStateMachine.owner)
	minionStateMachine.owner.collision = colisao
		
		
	return minionStateMachine
end
return MinionStateMachine
